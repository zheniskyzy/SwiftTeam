//
//  CurrentUserProfileView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import Firebase

struct CurrentUserProfileView: View {
    /// User Log Status
    @AppStorage("log_Status") private var logStatus: Bool = false
    var body: some View {
        VStack(spacing: 50) {
            Text("Profile")
                .font(.title.bold())
                .padding(.bottom, 30)
            
            
            Button("LogOut") {
                try? Auth.auth().signOut()
                logStatus = false
            }
            
        }
    }
}

#Preview {
    CurrentUserProfileView()
}

// DubaiLove_2022
