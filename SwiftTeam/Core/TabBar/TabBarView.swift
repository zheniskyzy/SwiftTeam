//
//  TabBarView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI

/// Tab"s
enum Tab: String, CaseIterable {
    case home = "square.on.square.dashed"
    case search = "magnifyingglass"
    case create = "pencil.tip"
    case notification = "app.badge"
    case profile = "person"
}

/// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}

/// Tab Bar View
struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap{ tab -> AnimatedTab? in
        return .init(tab: tab)
    }
    
  //  @State private var showSignInView: Bool = false
    
    
    @State private var tabState: Visibility = .visible
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                /// Tab Views
                FeedView()
                    .background(Color.theme.bgTabColor)
                    .onAppear { selectedTab = 0 }
                    .tag(0)
                    .setUpTab(.home)
                
                    ExploreView()
                        .background(Color.theme.bgTabColor)
                .onAppear { selectedTab = 1 }
                .tag(1)
                .setUpTab(.search)
                
                CreateDummyView(tabIndex: $selectedTab)
                    .background(Color.theme.bgTabColor)
                    .onAppear { selectedTab = 2 }
                    .tag(2)
                    .setUpTab(.create)
                
                ActivityView()
                    .background(Color.theme.bgTabColor)
                    .onAppear { selectedTab = 3 }
                    .tag(3)
                    .setUpTab(.notification)
                
                CurrentUserProfileView()
                    .background(Color.theme.bgTabColor)
                    .onAppear { selectedTab = 4 }
                    .tag(4)
                    .setUpTab(.profile)
            }
            
            CustomTabBar()
                .background(Color.theme.bgTabColor)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4) {
                    Image(systemName: tab.rawValue)
                        .font(.title2)
                        .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimating)
                    
    //                    Text(tab.title)
    //                        .font(.caption2)
    //                        .textScale(.secondary)
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(selectedTab == Tab.allCases.firstIndex(of: tab)! ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
              //  .padding(.bottom, 44)
               // .contentShape(.rect)
                // You Can Also Use Button, If you Choose to
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete, {
                        selectedTab = Tab.allCases.firstIndex(of: tab)!
                        animatedTab.isAnimating = true
                    }, completion: {
                        var trasnaction = Transaction()
                        trasnaction.disablesAnimations = true
                        withTransaction(trasnaction) {
                            animatedTab.isAnimating = nil
                        }
                    })
                }
            }
        }
    }

}

#Preview {
    TabBarView()
}

extension View {
    @ViewBuilder
    func setUpTab(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
      //      .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
}
