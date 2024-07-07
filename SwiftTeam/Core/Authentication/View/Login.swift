//
//  Login.swift
//  SwiftTeam
//
//  Created by Benji Loya on 30.06.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

struct Login: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    
    /// View Properties
    @Environment(\.colorScheme) private var scheme
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @State private var nonce: String?
    /// User Log Status
    @AppStorage("log_Status") private var logStatus: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader {
                let size = $0.size
                
                Image(.BG)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -60)
                    .frame(width: size.width, height: size.height)
            }
            /// Gradient Masking At Bottom
            .mask {
                Rectangle()
                    .fill(
                        .linearGradient(
                            colors: [
                                .white,
                                .white,
                                .white,
                                .white,
                                .white.opacity(0.9),
                                .white.opacity(0.6),
                                .white.opacity(0.2),
                                .clear,
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .ignoresSafeArea()
            
            /// Sign In Button
            VStack(alignment: .leading) {
                Text("Sign in to start your \nlearning experience")
                    .font(.title.bold())
                
                //Google
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                            logStatus = true
                        } catch {
                            print(error)
                        }
                    }
                }
                .scaleEffect(0.9)
                .overlay {
                    ZStack {
                        Capsule()
                            .foregroundStyle(.blue)
                        
                        HStack(spacing: 10) {
                            Image(.google)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 16, height: 16)
                                .clipShape(Circle())
                                .padding(1)
                                .background(Color.white)
                                .clipShape(Circle())
                            
                            Text("Sign in with Google")
                        }
                        .foregroundStyle(scheme == .dark ? .white : .white)
                    }
                    .allowsHitTesting(false)
                }
                .frame(height: 45)
                .clipShape(.capsule)
                .padding(.top, 10)
                
                // Apple
                Button(action: {
                    Task {
                        do {
                            try await viewModel.signInApple()
                            logStatus = true
                        } catch {
                            print(error)
                        }
                    }
                }, label: {
                    SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                        .allowsHitTesting(false)
                })
                .overlay {
                    ZStack {
                        Capsule()
                        
                        HStack(spacing: 10) {
                            Image(systemName: "applelogo")
                            
                            Text("Sign in with Apple")
                        }
                        .foregroundStyle(scheme == .dark ? .black : .white)
                    }
                    .allowsHitTesting(false)
                }
                .frame(height: 45)
                .clipShape(.capsule)
                
                /// Other Sign In Options
                Button(action: {
                    
                }, label: {
                    Text("Other Sign in Options")
                        .foregroundStyle(Color.primary)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .contentShape(.capsule)
                        .background {
                            Capsule()
                                .stroke(Color.primary, lineWidth: 0.5)
                        }
                })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
        }
        .alert(errorMessage, isPresented: $showAlert) { }
        .overlay {
            if isLoading {
                LoadingScreen()
            }
        }
    }
    
    /// Loading Screen
    @ViewBuilder
    func LoadingScreen() -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            
            ProgressView()
                .frame(width: 45, height: 45)
                .background(.background, in: .rect(cornerRadius: 5))
        }
    }
    
    /// Presenting Error's
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
}

#Preview {
    Login()
}
