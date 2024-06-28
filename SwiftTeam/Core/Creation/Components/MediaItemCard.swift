//
//  MediaItemCard.swift
//  MyThreads
//
//  Created by Benji Loya on 26.05.2024.
//

import SwiftUI

struct MediaItemCard: View {
    let mediaItem: MediaItem
    let size: CGSize
    let index: Int
    let onDelete: () -> Void
    @Binding var currentVisibleIndex: Int
    @Binding var isPlaying: Bool
    @Binding var isMuted: Bool
    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            switch mediaItem.type {
            case .image(let image):
                imageView(image)
            case .video(let videoURL):
                videoView(videoURL)
            }
        }
        .frame(width: size.width * 0.45, height: size.height)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(deleteButton, alignment: .topTrailing)
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: VisibleIndexKey.self, value: geo.frame(in: .global).midX < size.width / 2 ? index : nil)
            }
        )
        .onChange(of: currentVisibleIndex) { oldValue, newValue in
            isPlaying = newValue == index
        }
    }

    private func imageView(_ image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }

    private func videoView(_ videoURL: URL) -> some View {
        VideoPlayerCustom(
            mediaURL: videoURL,
            isMuted: $isMuted,
            isPlaying: $isPlaying,
            isLoading: $isLoading
        )
        .overlay(muteButton, alignment: .bottomTrailing)
    }

    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "xmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.white, .black.opacity(0.4))
                .padding(8)
                .background(Color.black.opacity(0.001))
        }
    }

    private var muteButton: some View {
        Button(action: {
            withAnimation(.bouncy) {
                isMuted.toggle()
            }
        }) {
            Image(systemName: isMuted ? "speaker.slash.circle.fill" : "speaker.circle.fill")
                .font(.title3)
                .foregroundStyle(.white, .black.opacity(0.4))
                .padding(8)
                .background(Color.black.opacity(0.001))
                .clipShape(Circle())
        }
        .padding(5)
    }
}

#Preview {
    CreatePostView(tabIndex: .constant(0))
}
