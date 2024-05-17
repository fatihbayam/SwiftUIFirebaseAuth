//
//  SignInEmailViewModel.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 13.05.2024.
//

import Foundation

@MainActor
final class SignInEMailViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
      
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
