//
//  NewScreen.swift
//  SwiftTeam
//
//  Created by Benji Loya on 04.07.2024.
//


import SwiftUI
import SwiftfulRouting

struct NewScreen: View {
    @Environment(\.router) var router
    var selectedCard: CategoryCard
    
    @State var news: [News] = []
    
    // To show dynamic...
    @State var columns: Int = 2
    
    // Smooth Hero Effect...
    @Namespace var animation
    
    var body: some View {
        VStack {
            
            HeaderView()
            
                            
                StaggeredGrid(columns: columns, list: news, content: { post in
                    
                    // Post Card View...
                    NewsCardView(post: post)
                        .matchedGeometryEffect(id: post.id, in: animation)
                        .onAppear {
                            print(post.imageURL)
                        }
                })
                .padding(.horizontal)
                // animation...
                .animation(.easeInOut, value: columns)
            
            .onAppear {
                
                for index in 1...10{
                    news.append(News(imageURL: "post\(index)"))
                }
            }
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
            HStack(alignment: .center, spacing: 20) {
                
                Image(systemName: "arrow.left.circle")
                    .font(.system(size: 26))
                    .fontWeight(.light)
                        .foregroundStyle(.primary.opacity(0.7))
                        .onTapGesture {
                            router.dismissScreen()
                        }
                
                Spacer()
                
                Button {
                    columns += 1
                } label: {
                    Image(systemName: "plus")
                }
                
                Button {
                    columns = max(columns - 1, 1)
                } label: {
                    Image(systemName: "minus")
                }
                
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
        NewScreen(selectedCard: categoryCards[0])
    }
}


// since we declared T as Identifiable...
// so we need to pass Idenfiable conform collection/Array...

struct NewsCardView: View{
    
    var post: News
    
    var body: some View{
        
        Image(post.imageURL)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}
