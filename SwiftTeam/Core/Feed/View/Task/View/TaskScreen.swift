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
    @State private var cards: [TaskCard] = sampleTaskcards
    // Detail Hero Page..
    @State private var showDetailPage: Bool = false
    @State private var currentCard: TaskCard?
    // For Hero Animation
    // Using Namespace...
    @Namespace private var animation
    // showing Detail content a bit later...
    @State private var showDetailContent: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            HeaderView()
            
            VStack(alignment: .leading) {
                
                GeometryReader{proxy in
                    
                    let size = proxy.size
                    
                    // your Wish...
                    let trailingCardsToShown: CGFloat = 2
                    let trailingSpaceofEachCards: CGFloat = 20
                    
                    ZStack{
                        ForEach(cards){card in
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
                    .frame(height: size.height / 1.8)
                // Your Wish...
                // Make Cards size as 1.6 of th the height...
                
                // Since Geometry Reader push away all View to leading..
                // Making it Center...
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
            }
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
    
    /*
    // MARK: - Detail
    @ViewBuilder
    func DetailPage()->some View{
        ZStack{
            if let currentCard = currentCard,showDetailPage {
                
                Rectangle()
                    .fill(currentCard.cardColor)
                    .matchedGeometryEffect(id: currentCard.id, in: animation)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    // Close Button...
                    Button {
                        withAnimation{
                            // Closing View..
                            showDetailContent = false
                            showDetailPage = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white.opacity(0.6))
                            .clipShape(Circle())
                    }
                    // Moving view to left Without Any Spacers..
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Text(currentCard.date)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .padding(.top)

                    Text(currentCard.title)
                        .font(.title.bold())
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        // Sample Content...
                        Text(content)
                            .kerning(1.1)
                            .lineSpacing(8)
                            .multilineTextAlignment(.leading)
                            .padding(.top,10)
                    }
                }
                .opacity(showDetailContent ? 1 : 0)
                .foregroundColor(.white)
                .padding()
                // Moving view to top Without Any Spacers..
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        
                        withAnimation{
                            showDetailContent = true
                        }
                    }
                }
            }
        }
    }
    */
    
}

#Preview {
    RouterView { _ in
        TaskScreen(selectedCard: categoryCards[1])
    }
}

/*
//MARK: - Infinite Stacked CardView
struct InfiniteStackedCardView: View {
    
    @Binding var cards: [TaskCard]
    var card: TaskCard
    var trailingCardsToShown: CGFloat
    var trailingSpaceofEachCards: CGFloat
    
    // For Hero Animation...
    var animation: Namespace.ID
    @Binding var showDetailPage: Bool
    
    // Gesture Properties...
    // Used to tell whether user is Dragging Cards...
    @GestureState var isDragging: Bool = false
    // Used to store Offset..
    @State var offset: CGFloat = .zero
    
    var body: some View{
        
        VStack(alignment: .leading, spacing: 15) {
            
            Text(card.date)
                .font(.caption)
                .fontWeight(.semibold)
                
            Text(card.title)
                .font(.title.bold())
                .padding(.top)
            
            Spacer()
            
            // Since I need icon at right
            // Simply swap the content inside label...
            Label {
                Image(systemName: "arrow.right")
            } icon: {
                Text("Let's start")
            }
            .font(.system(size: 15, weight: .semibold))
            // Moving To right without Spacers...
            .frame(maxWidth: .infinity,alignment: .trailing)

        }
        .padding()
        .padding(.vertical,10)
        .foregroundColor(.white)
        // Giving Background Color
        .background(
        
            ZStack{
                // Ignore Warnings...
                // if you want smooth animation...
                
                // Matched Geometry effect not animating smoothly when we hide the original content...
                // don't avoid original content if you want smooth animation...
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(card.cardColor)
                    .matchedGeometryEffect(id: card.id, in: animation)
            }
        )
        .padding(.trailing,-getPadding())
        // Applying vertical padding...
        // to look like shirnking...
        .padding(.vertical,getPadding())
        // since we use ZStack all cards are reversed...
        // Simply undoing with the help of ZIndex..
        .zIndex(Double(CGFloat(cards.count) - getIndex()))
        .rotationEffect(.init(degrees: getRotation(angle: 10)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .offset(x: offset)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    
                    var translation = value.translation.width
                    // Applying Translation for only First card to avoid dragging bottom Cards...
                    translation = cards.first?.id == card.id ? translation : 0
                    // Applying dragging only if its dragged..
                    translation = isDragging ? translation : 0
                    
                    // Stopping Right Swipe...
                    translation = (translation < 0 ? translation : 0)
                    
                    offset = translation
                })
                .onEnded({ value in
                    // Checking if card is swiped more than width...
                    let width = UIScreen.main.bounds.width
                    let cardPassed = -offset > (width / 3.1)
                    
                    withAnimation(.easeInOut(duration: 0.2)){
                        if cardPassed{
                            offset = -width
                            removeAndPutBack()
                        }
                        else{
                            offset = .zero
                        }
                    }
                })
        )
    }
    
    // removing Card from first and putting it back at last so it look like infinite staked carousel without using Memory...
    func removeAndPutBack(){
        
        // Removing card after animation finished...
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            // Updating card id
            // to avoid Foreach Warning...
            var updatedCard = card
            updatedCard.id = UUID().uuidString
            
            cards.append(updatedCard)
            
            withAnimation {
                // removing first card...
                cards.removeFirst()
            }
        }
    }
    
    // Rotating Card while Dragging...
    func getRotation(angle: Double)->Double{
        // Removing Paddings...
        let width = UIScreen.main.bounds.width - 50
        let progress = offset / width
        
        return Double(progress) * angle
    }
    
    func getPadding()->CGFloat{
        // retreiving padding for each card(At trailing...)
        let maxPadding = trailingCardsToShown * trailingSpaceofEachCards
        
        let cardPadding = getIndex() * trailingSpaceofEachCards
        
        // retuning only number of cards declared...
        return (getIndex() <= trailingCardsToShown ? cardPadding : maxPadding)
    }
    
    // Retreiving Index to find which card need to show...
    func getIndex()->CGFloat{
        
        let index = cards.firstIndex { card in
            return self.card.id == card.id
        } ?? 0
        
        return CGFloat(index)
    }
    
}
*/


