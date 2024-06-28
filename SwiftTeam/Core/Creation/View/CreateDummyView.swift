//
//  CreateThreadDummyView.swift
//  Threads
//
//  Created by Benji Loya on 23.04.2023.
//

import SwiftUI

struct CreateDummyView: View {
    @State private var presented = false
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack { }
        .onAppear { presented = true }
        .sheet(isPresented: $presented) {
            CreatePostView(tabIndex: $tabIndex)
                .interactiveDismissDisabled()
        }
    }
}

struct CreateThreadDummyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateDummyView(tabIndex: .constant(0))
    }
}
