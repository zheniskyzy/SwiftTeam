//
//  CreateThreadView.swift
//  Threads
//
//  Created by Benji Loya on 23.04.2023.
//

import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = CreatePostViewModel()
    
    @Binding var tabIndex: Int
    
  //  private var user: User? {
     //   return UserService.shared.currentUser
   // }
    
    @State private var showPhotoPicker = false
    @State private var currentVisibleIndex: Int = 0
    @State private var isMuted: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider()
            
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    titlePost
                        .padding(.horizontal, 10)
                    
                    if !viewModel.mediaFiles.isEmpty {
                        mediaCarousel
                            .padding(.top)
                            .safeAreaPadding(.leading, 55)
                            .safeAreaPadding(.trailing, 10)
                    }
                    
                    HStack {
                        // Buttons
                        AddThreadButtons(
                            vmThread: viewModel,
                            onCameraPressed: nil,
                            onMicrophonePressed: nil,
                            onHashtagPressed: nil,
                            onMenuPressed: nil
                        )
                    }
                    .padding(.leading, 55)
                    .padding(.top, 15)
                    
                    Spacer(minLength: 0)
                    
                }
                .padding(.top, 15)
                .onChange(of: viewModel.mediaSelections) { oldValue, newValue in
                    Task {
                        await viewModel.setMedia()
                    }
                }
                .onPreferenceChange(VisibleIndexKey.self) { index in
                    guard let index = index else { return }
                    currentVisibleIndex = index
                }
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.never)
        }
        .onDisappear { tabIndex = 0 }
        .onAppear {
            isTextFieldFocused = true
        }
        .background(Color.theme.bgTabColor)
        
    }
    
    //MARK: - Header
    private var header: some View {
        HStack(spacing: 0) {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
            }
            
            Spacer(minLength: 0)
            
            Button {
                dismiss()
                Task {
                    try await viewModel.uploadThread()
                }
            } label: {
                Text("Post")
            }
            .opacity((viewModel.caption.isEmpty && viewModel.mediaFiles.isEmpty) ? 0.5 : 1.0)
            .disabled(viewModel.caption.isEmpty && viewModel.mediaFiles.isEmpty)
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity)
        .padding(20)
        .overlay(
            Text("New Post")
                .fontWeight(.semibold)
        )
    }
    
    //MARK: - User INFO & Text post
    private var titlePost: some View {
        HStack(alignment: .top, spacing: 0) {
         //   CircularProfileImageView(user: user, size: .small)
            
            VStack(alignment: .leading, spacing: 6) {
              //  Text(user?.username ?? "")
                Text("benjiloya")
                    .textScale(.secondary)
                    .fontWeight(.semibold)
                
                TextField("What's new?", text: $viewModel.caption, axis: .vertical)
                    .font(.system(size: 14))
                    .focused($isTextFieldFocused)
                
            }
            .padding(.leading, 12)
            
            Spacer(minLength: 0)
            
            if !viewModel.caption.isEmpty {
                ZStack {
                    Button {
                        viewModel.caption = ""
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.secondary)
                            .padding(10)
                            .background(Color.black.opacity(0.001))
                            .clipShape(Circle())
                            .offset(y: 21)
                    }
                }
            }
        }
    }
    
    //MARK: - Post Media
    private var mediaCarousel: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(viewModel.mediaFiles.indices, id: \.self) { index in
                        let mediaItem = viewModel.mediaFiles[index]
                        MediaItemCard(
                            mediaItem: mediaItem,
                            size: geometry.size,
                            index: index,
                            onDelete: {
                                viewModel.deleteMediaItem(at: index)
                                if currentVisibleIndex >= viewModel.mediaFiles.count {
                                    currentVisibleIndex = max(viewModel.mediaFiles.count - 1, 0)
                                }
                            },
                            currentVisibleIndex: $currentVisibleIndex,
                            isPlaying: .constant(currentVisibleIndex == index),
                            isMuted: $isMuted
                        )
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        }
        .frame(height: 200)
    }
}

struct CreateThreadView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(tabIndex: .constant(0))
    }
}
