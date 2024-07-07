//
//  TaskDetailView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 07.07.2024.
//

import SwiftUI

struct TaskDetailView: View {
    
    var currentCard: TaskCard?
    @Binding var showDetailPage: Bool
    @Binding var showDetailContent: Bool
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
            if let currentCard = currentCard, showDetailPage {
                
                Rectangle()
                    .fill(currentCard.cardColor)
                    .matchedGeometryEffect(id: currentCard.id, in: animation)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    // Close Button...
                    Button {
                        withAnimation {
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                            .padding(.top, 10)
                    }
                }
                .opacity(showDetailContent ? 1 : 0)
                .foregroundColor(.white)
                .padding()
                // Moving view to top Without Any Spacers..
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        
                        withAnimation {
                            showDetailContent = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @State var showDetailPage: Bool = true
    @State var showDetailContent: Bool = true
    @Namespace var animation

    return TaskDetailView(
        currentCard: sampleTaskcards.first!,
        showDetailPage: $showDetailPage,
        showDetailContent: $showDetailContent,
        animation: animation
    )
}

let content = "Humans have long used cognitive enhancement methods to expand the proficiency and range of the various mental activities that they engage in, including writing to store and retrieve information, and computers that allow them to perform myriad activities that are now commonplace in the internet age. Neuroenhancement describes the use of neuroscience-based techniques for enhancing cognitive function by acting directly on the human brain and nervous system, altering its properties to increase performance. Cognitive neuroscience has now reached the point where it may begin to put theory derived from years of experimentation into practice. This special issue includes 16 articles that employ or examine a variety of neuroenhancement methods currently being developed to increase cognition in healthy people and in patients with neurological or psychiatric illness.This includes transcranial electromagnetic stimulation methods, such as transcranial direct current stimulation (tDCS) and transcranial magnetic stimulation (TMS), along with deep brain stimulation, neurofeedback, behavioral training techniques, and these and other techniques in conjunction with neuroimaging."
