//
//  MediaTransferable.swift
//  MyThreads
//
//  Created by Benji Loya on 26.05.2024.
//

import SwiftUI

//MARK: - Error
enum TransferError: Error {
   case couldNotLoadData
}

//MARK: - Transferable
struct ImagePickerTransferable: Transferable {
   let image: UIImage
    
   static var transferRepresentation: some TransferRepresentation {
       DataRepresentation(importedContentType: .image) { data in
           // Создаем изображение из данных
           guard let uiImage = UIImage(data: data) else {
               throw TransferError.couldNotLoadData
           }
           return .init(image: uiImage)
       }
   }
}

struct VideoPickerTransferable: Transferable {
    let videoURL: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            return .init(exportingFile.videoURL)
        } importing: { ReceivedTransferredFile in
            let originalFile = ReceivedTransferredFile.file
            let uniqueName = UUID().uuidString
            let copiedFile = URL.documentsDirectory.appendingPathComponent(uniqueName + ".mov")
            try FileManager.default.copyItem(at: originalFile, to: copiedFile)
            return .init(videoURL: copiedFile)
        }
    }
}
