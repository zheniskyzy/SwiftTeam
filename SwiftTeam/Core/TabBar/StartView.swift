//
//  StartView.swift
//  SwiftTeam
//
//  Created by Benji Loya on 28.06.2024.
//

import SwiftUI

struct StartView: View {
    
    @State private var text = "Hello"
    @State private var trigger = false
    
    var body: some View {
        ZStack {
           Color.theme.bgTabColor
                .ignoresSafeArea()
            
                HaskTextView(
                    text: text,
                    trigger: trigger,
                    transition: .identity,
                    speed: 0.05
                )
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)
                .onAppear {
                    updateGreeting()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.bouncy) {
                            trigger.toggle()
                        }
                    }
                }
        }
    }
    
    func updateGreeting() {
           let hour = Calendar.current.component(.hour, from: Date())
           
           switch hour {
           case 6..<12:
               text = "Good Morning"
           case 12..<18:
               text = "Hello"
           case 18..<22:
               text = "Welcome Back"
           default:
               text = "Good Night"
           }
       }
}

#Preview {
    StartView()
}
