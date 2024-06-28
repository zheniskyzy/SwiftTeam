//
//  ExploreView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import SwiftfulUI

struct ExploreView: View {
    
    @State private var filters = FilterModel.mockArray
    @State private var selectedFilter: FilterModel? = nil
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
                CategoriesBarView(
                    filters: filters,
                    selectedFilter: selectedFilter,
                    onFilterPressed: { newFilter in
                        selectedFilter = newFilter
                    },
                    onXMarkPressed: {
                        selectedFilter = nil
                    }
                )
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
                     //   .background(.ultraThinMaterial.opacity(0.99))
                     //   .brightness(-0.3)
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
         //   VStack(alignment: .leading, spacing: 3) {
               
                Text("Search")
                    .font(.system(size: 23, weight: .semibold, design: .default))
         //   }
            
            Spacer(minLength: 0)
            
                Image(systemName: "magnifyingglass")
                .font(.title)
                    .foregroundStyle(.gray)
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
                    
                //    if let heroProduct {
                   //     heroCell(product: heroProduct)
               //     }
                    
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
    
}

#Preview {
    ExploreView()
}
