//
//  CurrentUserProfileView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import Firebase
import SwiftfulRouting

struct CurrentUserProfileView: View {
    @Environment(\.router) var router
    
    var body: some View {
        CustomRefreshView(showsIndicator: false) {
            VStack(spacing: 50) {
                HeaderView()
                
               
                
            }
            .scrollIndicators(.hidden)
        } onRefresh: {
            // MARK: Your Action
        }
        
       
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
                                SettingsView()
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
        
      //  .padding(.top,safeArea().top)
        .padding(.bottom, 10)
        .background {
            Color.theme.bgTabColor
        }
        .padding(.bottom, 20)
    }
    
}

#Preview {
    RouterView { _ in
        CurrentUserProfileView()
    }
}
