//
//  FeedView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import SwiftfulRouting
import SwiftfulUI

// MARK: Swipe Direction
enum SwipeDirection{
    case up
    case down
    case none
}

struct FeedView: View {
    @Environment(\.router) var router
    /// MARK: View Properties
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction: SwipeDirection = .none
    /// MARK: Shift Offset Means The Value From Where It Shifted From Up/Down
    @State var shiftOffset: CGFloat = 0
    var body: some View {
      
        ScrollView(.vertical, showsIndicators: false) {
            
            DummyFeedView()
                .padding(.top,headerHeight)
                .offsetY { previous, current in
                    // MARK: Moving Header Based On Direction Scroll
                    if previous > current{
                        // MARK: Up
                        // print("Up")
                        if direction != .up && current < 0{
                            shiftOffset = current - headerOffset
                            direction = .up
                            lastHeaderOffset = headerOffset
                        }
                        
                        let offset = current < 0 ? (current - shiftOffset) : 0
                        // MARK: Checking If It Does Not Goes Over Over Header Height
                        headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                    }else{
                        // MARK: Down
                        // print("Down")
                        if direction != .down{
                            shiftOffset = current
                            direction = .down
                            lastHeaderOffset = headerOffset
                        }
                        
                        let offset = lastHeaderOffset + (current - shiftOffset)
                        headerOffset = (offset > 0 ? 0 : offset)
                    }
                }
            
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .top) {
            HeaderView()
                .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){$0}
                .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                    GeometryReader{proxy in
                        if let anchor = value{
                            Color.clear
                                .onAppear {
                                    // MARK: Retreiving Rect Using Proxy
                                    headerHeight = proxy[anchor].height
                                }
                        }
                    }
                }
                .offset(y: -headerOffset < headerHeight ? headerOffset : (headerOffset < 0 ? headerOffset : 0))
        }
        // MARK: Due To Safe Area
        .ignoresSafeArea(.all, edges: .top)
        
       
        
        
    }
    
    // MARK: - Header
    @ViewBuilder
    func HeaderView()->some View{
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
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
            
            Divider()
                .offset(y: 10)
        }
        
        .padding(.top,safeArea().top)
        .padding(.bottom, 10)
        .background {
            Color.theme.bgTabColor
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Dummy Feed View
    @ViewBuilder
    func DummyFeedView()->some View{
        VStack(spacing: 30){
            ForEach(0..<20, id: \.self) { _ in
                HStack(alignment: .top, spacing: 15) {
                    Circle()
                        .frame(width: 55, height: 55)
                    
                    VStack(alignment: .leading, spacing: 6, content: {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 140, height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame( height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 80, height: 80)
                    })
                }
                .foregroundStyle(.gray.opacity(0.25))
                .padding(.horizontal, 10)
            }
        }
        .shimmer(.init(tint: .gray.opacity(0.25), highlight: .primary.opacity(0.5), blur: 25))
    }
}

#Preview {
    RouterView { _ in
        FeedView()
    }
}
