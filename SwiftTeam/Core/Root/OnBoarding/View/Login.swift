//
//  Login.swift
//  SwiftTeam
//
//  Created by Benji Loya on 30.06.2024.
//

import SwiftUI
import AuthenticationServices
import Firebase
import CryptoKit

struct Login: View {
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
                
                SignInWithAppleButton(.signIn) { request in
                    let nonce = randomNonceString()
                    self.nonce = nonce
                    /// your Preferences
                    request.requestedScopes = [.email, .fullName]
                    request.nonce = sha256(nonce)
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        loginWithFirebase(authorization)
                    case .failure(let error):
                        showError(error.localizedDescription)
                    }
                }
                .overlay {
                    ZStack {
                        Capsule()
                        
                        HStack {
                            Image(systemName: "applelogo")
                            
                            Text("Sign in with Apple")
                        }
                        .foregroundStyle(scheme == .dark ? .black : .white)
                    }
                    .allowsHitTesting(false)
                }
                .frame(height: 45)
                .clipShape(.capsule)
                .padding(.top, 10)
                
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
    
    /// Login With Firebase
    func loginWithFirebase(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
     /// Showing Loading Screen Until Login Completes With Firebase
            isLoading = true
            guard let nonce else {
           // fatalError("Invalid state: A login callback was received, but no login request was sent.")
              showError("Cannot progress your request")
              return
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
          //  print("Unable to fetch identity token")
              showError("Cannot progress your request")
              return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          //  print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              showError("Cannot progress your request")
              return
          }
          // Initialize a Firebase credential, including the user's full name.
          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                            rawNonce: nonce,
                                                            fullName: appleIDCredential.fullName)
          // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    showError(error.localizedDescription)
                    
                }
                // User is signed in to Firebase with Apple.
                /// Pushing User to Home View
                logStatus = true
                isLoading = false
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}

#Preview {
    Login()
}


/*
 Button("LogOut") {
 try? Auth.auth().signOut()
 }
 */
