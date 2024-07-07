//
//  ContentView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI
import SwiftfulRouting

struct ContentView: View {
    @Environment(\.router) var router
    @State var showStartView: Bool = true
    /// User Log Status
    @AppStorage("log_Status") private var logStatus: Bool = false
    var body: some View {
        VStack {
            if showStartView {
                StartView()
                    .transition(.opacity) // Добавляет анимацию перехода (по желанию)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showStartView = false
                            }
                        }
                    }
            } else {
                Group {
                    if logStatus {
                        TabBarView()
                            .accentColor(.primary)
                    } else {
                        LoginView()
                    }
                        
                }
            }
        }
    }
}

#Preview {
    RouterView { _ in
        ContentView()
    }
}
