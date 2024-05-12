//
//  SettingsViewModel.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published var authUser: AuthDataResultModel? = nil
    
    func  loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    
}

