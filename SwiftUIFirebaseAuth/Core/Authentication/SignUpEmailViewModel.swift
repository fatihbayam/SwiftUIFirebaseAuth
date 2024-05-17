//
//  SignUpEmailViewModel.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 16.05.2024.
//

import Foundation

@MainActor
final class SignUpEMailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var authUser: AuthDataResultModel? = nil
    
    func  loadAuthUser() async throws {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func linkEmailAccount() async throws {
        print("DEBUG: Linked Email Account")
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)

        if let authDataResult = self.authUser {
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.linkedAnonymousUserToEmail(user: user)
        }
    }
    
    func signUp() async throws {
        print("DEBUG: Create New User")
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
    
    func createNewUser() async throws {

        var newUser: Bool = true
        
        print("DEBUG: Connected user uid : \(String(describing: self.authUser?.uid))")
        if self.authUser?.uid == nil {
            print("DEBUG: New User")
            newUser = true
        } else {
            print("DEBUG: Link Email")
            newUser = false
        }
        
        if newUser {
            try await signUp()
        } else {
            try await linkEmailAccount()
        }
    }
}
