//
//  CreateThreadViewModel.swift
//  Threads
//
//  Created by Benji Loya on 14.05.2023.
//

import Foundation
import PhotosUI
import SwiftUI

struct MediaItem: Identifiable {
    enum MediaType {
        case image(UIImage)
        case video(URL)
    }
    
    let id = UUID()
    let type: MediaType
}

//MARK: - Media Handler
protocol MediaHandler {
    var mediaFiles: [MediaItem] { get }
    var isVideoProcessing: Bool { get set }
    func setMedia(mediaSelections: [PhotosPickerItem]) async
    func deleteMediaItem(at index: Int)
    func updateMediaFiles(_ mediaFiles: [MediaItem])
}

//MARK: - Thread Uploader
protocol PostUploader {
    func uploadThread(caption: String, mediaFiles: [MediaItem]) async throws
}

//MARK: - Media Manager
class MediaManager: ObservableObject, MediaHandler {
    @Published var isVideoProcessing: Bool = false
    @Published private(set) var mediaFiles: [MediaItem] = []
    
    func setMedia(mediaSelections: [PhotosPickerItem]) async {
        isVideoProcessing = true
        defer { isVideoProcessing = false }
        
        var mediaItems: [MediaItem] = []
        
        for item in mediaSelections {
            do {
                if let pickedMovie = try await item.loadTransferable(type: VideoPickerTransferable.self) {
                    mediaItems.append(MediaItem(type: .video(pickedMovie.videoURL)))
                } else if let pickedImage = try await item.loadTransferable(type: ImagePickerTransferable.self) {
                    mediaItems.append(MediaItem(type: .image(pickedImage.image)))
                }
            } catch {
                print("Failed to load media: \(error.localizedDescription)")
            }
        }
        self.mediaFiles = mediaItems
    }
    
    func deleteMediaItem(at index: Int) {
        guard index >= 0 && index < mediaFiles.count else { return }
        mediaFiles.remove(at: index)
    }
    
    func updateMediaFiles(_ mediaFiles: [MediaItem]) {
        self.mediaFiles = mediaFiles
    }
}

//MARK: - Firebase  Uploader
class FirebasePostUploader: PostUploader {
    func uploadThread(caption: String, mediaFiles: [MediaItem]) async throws {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        var threadData: [String: Any] = [
//            "ownerUid": uid,
//            "caption": caption,
//            "timestamp": Timestamp(),
//            "likes": 0,
//            "replyCount": 0
//        ]
//        
//        var mediaFilesArray: [MediaFile] = []
//        
//        if !mediaFiles.isEmpty {
//            for mediaItem in mediaFiles {
//                switch mediaItem.type {
//                case .image(let image):
//                    if let imageUrl = try? await ImageUploader.uploadImage(image: image, type: .thread) {
//                        mediaFilesArray.append(MediaFile(url: imageUrl, type: .image))
//                    }
//                case .video(let videoURL):
//                    do {
//                        let videoData = try Data(contentsOf: videoURL)
//                        if let videoUrlString = try? await VideoUploader.uploadVideo(videoData: videoData, type: .threadVideo) {
//                            mediaFilesArray.append(MediaFile(url: videoUrlString, type: .video))
//                        }
//                    } catch {
//                        print("Failed to upload video: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//        
//        let mediaFilesDict = mediaFilesArray.map { ["url": $0.url, "type": $0.type.rawValue] }
//        threadData["mediaFiles"] = mediaFilesDict
//        
//        let db = Firestore.firestore()
//        let threadsRef = db.collection("threads")
//        
//        do {
//            try await threadsRef.addDocument(data: threadData)
//            print("Thread uploaded successfully!")
//        } catch {
//            print("Error uploading thread: \(error.localizedDescription)")
//        }
    }
}

//MARK: - Create  ViewModel
@MainActor
class CreatePostViewModel: ObservableObject {
    @Published var caption = ""
    @Published var mediaSelections: [PhotosPickerItem] = []
    private var mediaHandler: MediaHandler
    private let postUploader: PostUploader
    @Published var isVideoProcessing: Bool {
        didSet {
            mediaHandler.isVideoProcessing = isVideoProcessing
        }
    }
    @Published var mediaFiles: [MediaItem] {
        didSet {
            mediaHandler.updateMediaFiles(mediaFiles)
        }
    }

    init(mediaHandler: MediaHandler = MediaManager(), postUploader: PostUploader = FirebasePostUploader()) {
        self.mediaHandler = mediaHandler
        self.postUploader = postUploader
        self.isVideoProcessing = mediaHandler.isVideoProcessing
        self.mediaFiles = mediaHandler.mediaFiles
    }

    func deleteMediaItem(at index: Int) {
        mediaHandler.deleteMediaItem(at: index)
        self.mediaFiles = mediaHandler.mediaFiles
    }

    func uploadThread() async throws {
        try await postUploader.uploadThread(caption: caption, mediaFiles: mediaFiles)
    }

    func setMedia() async {
        await mediaHandler.setMedia(mediaSelections: mediaSelections)
        self.mediaFiles = mediaHandler.mediaFiles
    }
}
