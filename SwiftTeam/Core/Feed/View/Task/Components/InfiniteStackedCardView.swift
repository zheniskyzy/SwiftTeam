//
//  InfiniteStackedCardView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 07.07.2024.
//

import SwiftUI

struct InfiniteStackedCardView: View {
    
    @Binding var cards: [TaskLevel]
    var card: TaskLevel
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
               
            Text(card.title)
                .font(.title.bold())
                .padding(.top)
            
            Text(card.subtitle)
                .font(.caption)
                .fontWeight(.semibold)
            
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

#Preview {
    @State var sampleCards: [TaskLevel] = sampleTaskLevels
    @State var showDetailPage: Bool = false
    @Namespace var animation

    return InfiniteStackedCardView(
        cards: $sampleCards,
        card: sampleTaskLevels.first!,
        trailingCardsToShown: 2,
        trailingSpaceofEachCards: 20,
        animation: animation,
        showDetailPage: $showDetailPage
    )
}
