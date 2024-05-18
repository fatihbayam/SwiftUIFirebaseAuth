//
//  SettingsViewModel.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func  loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.badServerResponse)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    // MARK: Email functions
    func updateEmail() async throws {
        
        let email = "test1u@test.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        
        let password = "update123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
        if let authDataResult = self.authUser {
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.linkedAnonymousUserToGoogle(user: user)
        }

    }
    
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
        if let authDataResult = self.authUser {
            let user = DBUser(auth: authDataResult)
            try await UserManager.shared.linkedAnonymousUserToApple(user: user)
        }
    }
    
}

