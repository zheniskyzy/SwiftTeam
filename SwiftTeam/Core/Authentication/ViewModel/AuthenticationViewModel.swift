//
//  AuthenticationViewModel.swift
//  SwiftTeam
//
//  Created by Benji Loya on 06.07.2024.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class  AuthenticationViewModel: ObservableObject {
   
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
     //   let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
     //   let user = DBUser(auth: authDataResult)
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
    //    let user = DBUser(auth: authDataResult)
     //   try await UserManager.shared.createNewUser(user: user)
    }
    
}
