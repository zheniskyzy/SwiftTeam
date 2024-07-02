//
//  ActivityView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        CustomRefreshView(showsIndicator: false) {
            ScrollView(.vertical) {
                HStack {
                    Text("Activity")
                        .font(.title.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
            }
            .scrollIndicators(.hidden)
        } onRefresh: {
            // MARK: Your Action
        }
        
        
    }
}

#Preview {
    ActivityView()
}
