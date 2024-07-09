//
//  TaskScreen.swift
//  SwiftTeam
//
//  Created by Benji Loya on 04.07.2024.
//

import SwiftUI
import SwiftfulRouting

struct TaskScreen: View {
    @Environment(\.router) var router
    var selectedCard: CategoryCard
    
    // Sample State Cards...
    @State private var cards: [TaskLevel] = sampleTaskLevels
    // Detail Hero Page..
    @State private var showDetailPage: Bool = false
    @State private var currentCard: TaskLevel?
    // For Hero Animation
    // Using Namespace...
    @Namespace private var animation
    // showing Detail content a bit later...
    @State private var showDetailContent: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            HeaderView()
            
            VStack(alignment: .leading) {
                /// Cards
                GeometryReader { proxy in
                    
                    let size = proxy.size
                    
                    // your Wish...
                    let trailingCardsToShown: CGFloat = 2
                    let trailingSpaceofEachCards: CGFloat = 20
                    
                    ZStack{
                        ForEach(cards){ card in
                            InfiniteStackedCardView(cards: $cards, card: card,trailingCardsToShown: trailingCardsToShown,trailingSpaceofEachCards: trailingSpaceofEachCards,animation: animation,showDetailPage: $showDetailPage)
                            // Setting On tap...
                                .onTapGesture {
                                    withAnimation(.spring()){
                                        currentCard = card
                                        showDetailPage = true
                                    }
                                }
                        }
                    }
                    .padding(.leading,10)
                    .padding(.trailing,(trailingCardsToShown * trailingSpaceofEachCards))
                    .frame(height: size.height / 1.3)
                // Your Wish...
                // Make Cards size as 1.6 of th the height...
                
                // Since Geometry Reader push away all View to leading..
                // Making it Center...
                //    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
                /// Description
                VStack(alignment: .leading, spacing: 20) {
                    Text("Somethitng else...")
                        .font(.largeTitle.bold())
                    
                    Text("Somethitng else...")
                    Text("Somethitng else...")
                    Text("Somethitng else...")
                    Text("Somethitng else...")
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            .padding(.top, 30)
            .padding()
            // Moving view to Top without using Spacers...
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .overlay(
            //    DetailPage()
                TaskDetailView(
                    currentCard: currentCard,
                    showDetailPage: $showDetailPage,
                    showDetailContent: $showDetailContent,
                    animation: animation
                )
            )
            
        }
        .navigationBarBackButtonHidden()
        .background {
            Color.theme.bgTabColor
                .ignoresSafeArea()
        }
    }
    
    
    // MARK: - Header
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                
                    Image(systemName: "arrow.left.circle")
                        .font(.system(size: 26))
                        .fontWeight(.light)
                        .foregroundStyle(.primary.opacity(0.7))
                        .onTapGesture {
                            router.dismissScreen()
                        }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedCard.title)
                        .font(.system(size: 23, weight: .semibold, design: .default))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
        }
    }
    
}

#Preview {
    RouterView { _ in
        TaskScreen(selectedCard: categoryCards[1])
    }
}
