//
//  AuthenticationManager.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    let isAnonymous: Bool
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}


final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    
    // Sign Out
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Delete User
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await user.delete()
    }
    
}





// MARK: Sign in Anonymous

extension AuthenticationManager {
    
    @discardableResult
    func signInAnonymous() async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authDataResult.user)
    }
}
