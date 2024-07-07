//
//  DeleteAccountView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 07.07.2024.
//

import SwiftUI

struct DeleteAccountView: View {
    
    var onSubmit: () -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            
            Text("Delete Account?")
                .font(.title.bold())
            
            HStack(spacing: 25) {
                Button("Cancel") {
                   onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .tint(.primary)
                
                Button("Delete") {
                  onSubmit()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .tint(.red)
            }
            .padding(.top, 10)
        }
        .padding(15)
        .background(.bar, in: .rect(cornerRadius: 20))
        .padding(.horizontal, 30)
    }
}
