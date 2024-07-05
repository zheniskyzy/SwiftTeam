//
//  ChatScreen.swift
//  SwiftTeam
//
//  Created by Benji Loya on 04.07.2024.
//

import SwiftUI
import SwiftfulRouting

struct ChatScreen: View {
    @Environment(\.router) var router
    var selectedCard: CategoryCard
    
    var body: some View {
        VStack {
            
            HeaderView()
            
            ScrollView(.vertical) {
                VStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.clear)
                        .frame(width: 100, height: 200)
                    
                    Text(selectedCard.title)
                        .font(.title.bold())
                    
                    Text(selectedCard.subTitle)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
        }
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
                
                    Image(systemName: "chevron.backward.circle")
                        .font(.system(size: 26))
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
            
            Divider()
                .offset(y: 10)
        }
    }
    
}

#Preview {
    RouterView { _ in
        ChatScreen(selectedCard: categoryCards[2])
    }
}
