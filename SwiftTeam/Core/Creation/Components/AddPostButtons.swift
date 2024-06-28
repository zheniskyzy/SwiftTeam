//
//  AddPostButtons.swift
//  MyThreads
//
//  Created by Benji Loya on 26.05.2024.
//

import SwiftUI
import PhotosUI

struct AddThreadButtons: View {
    @ObservedObject var vmThread: CreatePostViewModel
    
    var onCameraPressed: (() -> Void)? = nil
    var onMicrophonePressed: (() -> Void)? = nil
    var onHashtagPressed: (() -> Void)? = nil
    var onMenuPressed: (() -> Void)? = nil
    var body: some View {
        HStack(spacing: 5) {
            PhotosPicker(
                selection: $vmThread.mediaSelections,
                maxSelectionCount: 10,
                selectionBehavior: .continuous,
                matching: .any(of: [.images, .videos]),
                preferredItemEncoding: .current,
                photoLibrary: .shared()
            ){
                Image(systemName: "photo.on.rectangle.angled")
                    .padding(5)
                    .background(Color.black.opacity(0.001))
            }
            
            Image(systemName: "camera.on.rectangle")
                .padding(5)
                .background(Color.black.opacity(0.001))
                .onTapGesture {
                    onCameraPressed?()
                }
            
            Image(systemName: "waveform.badge.mic")
                .padding(5)
                .background(Color.black.opacity(0.001))
                .onTapGesture {
                    onMicrophonePressed?()
                }
            
            Image(systemName: "number")
                .padding(5)
                .background(Color.black.opacity(0.001))
                .onTapGesture {
                    onHashtagPressed?()
                }
            
            Image(systemName: "line.3.horizontal.decrease")
                .padding(5)
                .padding(.vertical, 5)
                .background(Color.black.opacity(0.001))
                .onTapGesture {
                    onMenuPressed?()
                }
            
        }
        .font(.callout)
        .foregroundStyle(.primary.opacity(0.7))
        
    }
}

#Preview {
    let previewViewModel = CreatePostViewModel()
    return AddThreadButtons(vmThread: previewViewModel)
}
