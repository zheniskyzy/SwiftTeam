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
    @State private var headerHeight: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var lastHeaderOffset: CGFloat = 0
    @State private var direction: SwipeDirection = .none
    /// MARK: Shift Offset Means The Value From Where It Shifted From Up/Down
    @State private var shiftOffset: CGFloat = 0
    
    @State private var isLoading = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.clear)
                .frame(width: 200, height: 1)
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
            
            SpecialView()
            
            CategoriesView()
                .offset(y: -50)
            
            DummyFeedView()
                .offset(y: -50)
            
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
    func HeaderView() -> some View {
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
    
    // MARK: - Special
    @ViewBuilder
    func SpecialView() -> some View {
        VStack {
            HStack {
                Text("#SpecialForYou")
                    .font(.system(size: 18, weight: .semibold, design: .default))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            //MARK: - CARD
            /// Parallax Carousel
            GeometryReader(content: { geometry in
                let size = geometry.size
                
                ScrollView(.horizontal) {
                    HStack(spacing: 5) {
                        ForEach(categoryCards) { card in
                            ///In  Order to move the card in reverse direction (parallax effect)
                            GeometryReader(content: { proxy in
                                let cardSize = proxy.size
                                /// Simple Parallalx Effect (1)
                                // let minX = proxy.frame(in: .scrollView).minX
                                let minX = min((proxy.frame(in: .scrollView).minX - 30.0) * 0.4, proxy.size.width * 1.4)
                                
                                Image(card.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                /// Or u can simply use scalling
                                    .scaleEffect(1.25)
                                    .offset(x: -minX)
                                    .frame(width: proxy.size.width * 0.8)
                                    .frame(width: cardSize.width, height: cardSize.height)
                                    .overlay{
                                        OverlayView(card)
                                    }
                                    .clipShape(.rect(cornerRadius: 15))
                                    .shadow(color: .black.opacity(0.2), radius: 8, x: 5, y: 10)
//                                    .onTapGesture {
//                                        print("Tap card: \(card.title)")
//                                        router.showScreen(.push) { router in
//                                            SecondScreen(selectedCard: card)
//                                        }
//                                    }
                                
                                   
                                
                            })
                            .frame(width: size.width - 60, height: size.height - 50)
                            /// Scroll Animation
                            .scrollTransition(.interactive, axis: .horizontal) {
                                view, phase in
                                view
                                    .scaleEffect(phase.isIdentity ? 1 : 0.9)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    .scrollTargetLayout()
                    .frame(height: size.height, alignment: .top)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                
            })
            .frame(height: 200)
            .padding(.horizontal, -15)
          //  .redacted(reason: isLoading ? [] : .placeholder)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isLoading = true
                }
            }
           
            
        }
        
    }
    
    // MARK: - Categories
    @ViewBuilder
    func CategoriesView() -> some View {
        VStack(spacing: 10) {
            HStack {
                Text("Categories")
                    .font(.system(size: 18, weight: .semibold, design: .default))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<6) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.1))
                            .frame(width: UIScreen.main.bounds.width * 0.215, height: UIScreen.main.bounds.height * 0.1)
                            .overlay (
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray.opacity(0.4))
                            )
                    }
                }
            }
            .safeAreaPadding(.leading)
        }
        
    }
    
    // MARK: - Dummy Feed View
    @ViewBuilder
    func DummyFeedView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("Feature")
                    .font(.system(size: 18, weight: .semibold, design: .default))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            LazyVStack(spacing: 30) {
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
    
    /// Overlay View
    @ViewBuilder
    func OverlayView(_ card: CategoryCard) -> some View {
        ZStack(alignment: .bottomLeading, content: {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.25),
                .black.opacity(0.5)
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(card.title)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        })
        .onTapGesture {
            print("Tap card: \(card.title)")
            switch card.title {
            case "New":
                router.showScreen(.push) { _ in
                    NewScreen(selectedCard: card)
                }
            case "Task":
                router.showScreen(.push) { _ in
                    TaskScreen(selectedCard: card)
                }
            case "Chat":
                router.showScreen(.push) { _ in
                    ChatScreen(selectedCard: card)
                }
            case "Job":
                router.showScreen(.push) { _ in
                    JobScreen(selectedCard: card)
                }
            default:
                break
            }
        }
    }
    
}

#Preview {
    RouterView { _ in
        FeedView()
    }
}
