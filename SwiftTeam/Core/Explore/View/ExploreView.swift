//
//  ExploreView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import SwiftfulRouting

struct ExploreView: View {
    @Environment(\.router) var router
    // View Properties
    @State private var searchText: String = ""
    @FocusState private var isSearching: Bool
    @State private var activeTab: SearchTab = .all
    @Environment(\.colorScheme) private var scheme
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                DummyMessagesView()
            }
            .safeAreaPadding(15)
            .safeAreaInset(edge: .top, spacing: 0) {
                ExpandableNavigationBar()
            }
            .animation(.snappy(duration: 0.3, extraBounce: 0), value: isSearching)
        }
        .scrollTargetBehavior(CustomScrollTargetBehaviour())
        .scrollIndicators(.hidden)
        .background(Color.theme.bgTabColor)
        .contentMargins(.top, 190, for: .scrollIndicators)
    }
    
    /// Expandable Navigation Bar
    @ViewBuilder
    func ExpandableNavigationBar(_ title: String = "Search") -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
            let scrollviewHeight = proxy.bounds(of: .scrollView(axis: .vertical))?.height ?? 0
            let scaleProgress = minY > 0 ? 1 + (max(min(minY / scrollviewHeight, 1), 0) * 0.5) : 1
            
            let progress = isSearching ? 1 : max(min(-minY / 70, 1), 0)
            
            VStack(spacing: 10) {
                Text(title)
                    .font(.largeTitle.bold())
                    .scaleEffect(scaleProgress, anchor: .topLeading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                
                /// Search Bar
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                    
                    TextField("Search Conversations", text: $searchText)
                        .focused($isSearching)
                    
                    if isSearching {
                        Button(action: {
                            isSearching = false
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                        })
                        .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                    }
                }
                .foregroundStyle(Color.primary)
                .padding(.vertical, 10)
                .padding(.horizontal, 15 - (progress * 15))
                .frame(height: 45)
                .clipShape(.capsule)
                .background {
                    RoundedRectangle(cornerRadius: 25 - (progress * 25)) // u can use without progress RoundedRectangle(cornerRadius: 25)
                        .fill(.background)
                        .shadow(color: Color.theme.searchShadow, radius: 8, x: 0, y: 4)
                        .padding(.top, -progress * 190)
                        .padding(.bottom, -progress * 65)
                        .padding(.horizontal, -progress * 15)
                }
                
                /// Custom Segmented Picker
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(SearchTab.allCases, id: \.rawValue) { tab in
                            Button(action: {
                                withAnimation(.snappy) {
                                    activeTab = tab
                                }
                            }) {
                                Text(tab.rawValue)
                                    .font(.callout)
                                    .foregroundStyle(activeTab == tab ? (scheme == .dark ? .black : .white) : Color.primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 15)
                                    .background {
                                        if activeTab == tab {
                                            Capsule()
                                                .fill(Color.primary)
                                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                        } else {
                                            Capsule()
                                                .fill(.background)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .frame(height: 50)
                
            }
            .padding(.top, 25)
            .safeAreaPadding(.horizontal, 15)
            .offset(y: minY < 0 || isSearching ? -minY : 0)
            .offset(y: -progress * 65)
        }
        .frame(height: 190)
        .padding(.bottom, 10)
        .padding(.bottom, isSearching ? -65 : 0)
    }
    
    ///Dummy Messages View
    @ViewBuilder
    func DummyMessagesView() -> some View {
        ForEach(0..<20, id: \.self) { _ in
            HStack(spacing: 15) {
                Circle()
                    .frame(width: 55, height: 55)
                
                VStack(alignment: .leading, spacing: 6, content: {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 140, height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .frame( height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 80, height: 8)
                })
            }
            .foregroundStyle(.gray.opacity(0.25))
            .padding(.horizontal, 10)
        }
        .shimmer(.init(tint: .gray.opacity(0.25), highlight: .primary.opacity(0.5), blur: 25))
    }
}

struct CustomScrollTargetBehaviour: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        if target.rect.minY < 70 {
            if target.rect.minY < 35 {
                target.rect.origin = .zero
            } else {
                target.rect.origin = .init(x: 0, y: 70)
            }
        }
    }
}

#Preview {
    RouterView { _ in
        ExploreView()
    }
}
