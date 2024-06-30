//
//  FeedView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import SwiftfulRouting
import SwiftfulUI

struct FeedView: View {
    @Environment(\.router) var router
    
    @State private var fullHeaderSize: CGSize = .zero
    @State private var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.theme.bgTabColor.ignoresSafeArea()
            
            scrollViewLayer
            
            fullHeaderWithFilters
            
        }
        .task {
         //   await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    //MARK: - full Header
    private var fullHeaderWithFilters: some View {
        VStack(spacing: 0) {
         header
            
            if scrollViewOffset > -20 {
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 50)
                    .padding(.horizontal, 10)
                
                
                
                    .padding(.top, 16)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .padding(.bottom, 8)
        .background(
            ZStack {
                if scrollViewOffset < -70 {
                    Rectangle()
                        .fill(Color.clear)
                        .background {
                            TransparentBlurView(removeAllFilters: true)
                                .blur(radius: 9, opaque: true)
                                .background(Color.theme.primaryText.opacity(0.05))
                        }
                        .ignoresSafeArea()
                }
            }
        )
        .animation(.smooth, value: scrollViewOffset)
        .readingFrame { frame in
            if fullHeaderSize == .zero {
                fullHeaderSize = frame.size
            }
        }
    }
    
    //MARK: - Header
    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text("IOS Developer ll")
                    .font(.system(size: 12, weight: .light, design: .default))
                    .foregroundStyle(.primary.opacity(0.5))
                
                Text("benjiloya")
                    .font(.system(size: 23, weight: .semibold, design: .default))
                    .onTapGesture {
                        router.showScreen(.push) { _ in
                            // action view
                        }
                    }
            }
            
            Spacer(minLength: 0)
            
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundStyle(.gray.opacity(0.5))
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                    .onTapGesture {
                        // show full image
                    }
        }
        .padding(.horizontal, 15)
    }
    
    //MARK: - scrollView Layer
    private var scrollViewLayer: some View {
        ScrollViewWithOnScrollChanged(
            .vertical,
            showsIndicators: false,
            content: {
                VStack(spacing: 8) {
                    Rectangle()
                        .opacity(0)
                        .frame(height: fullHeaderSize.height)
                    
//                    if let heroProduct {
//                        heroCell(product: heroProduct)
//                    }
                    
//                    Text("\(scrollViewOffset)")
//                        .foregroundStyle(.red)
                    
                 //   categoryRows
                }
            },
            onScrollChanged: { offset in
                scrollViewOffset = min(0, offset.y)
            }
        )
    }
    
    /*
    //MARK: - heroCell
    private func heroCell(product: Product) -> some View {
        FeedHeroCell(
            imageName: product.firstImage,
            isNetflixFilm: true,
            title: product.title,
            categories: [product.category.capitalized, product.brand],
            onBackgroundPressed: {
                onProductPressed(product: product)
            },
            onPlayPressed: {
                onProductPressed(product: product)
            }
        )
        .padding(24)
    }
    
    private func onProductPressed(product: Product) {
        router.showScreen(.sheet) { _ in
          //  NetflixMovieDetailsView(product: product)
        }
    }
    */
}

#Preview {
    RouterView { _ in
        FeedView()
    }
}
