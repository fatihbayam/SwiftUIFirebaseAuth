//
//  UserManager.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine


struct DBUser: Codable {
    let userId: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    var isPremium: Bool?
    
    
    init(userId: String,
         isAnonymous: Bool? = nil,
         email: String? = nil,
         photoUrl: String? = nil,
         dateCreated: Date? = nil,
         isPremium: Bool? = nil
         
    )
    {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "user_isPremium"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
      }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
    }
    
    mutating func togglePremiumStatus() {
        let currentValue = isPremium ?? false
        isPremium = !currentValue
    }
}


final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user:DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        return try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func linkedAnonymousUserToEmail(user: DBUser) async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.isAnonymous.rawValue: user.isAnonymous,
            DBUser.CodingKeys.email.rawValue: user.email
        ]
        try await userDocument(userId: user.userId).updateData(data as [AnyHashable : Any])
    }
    
    func linkedAnonymousUserToGoogle(user: DBUser) async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.isAnonymous.rawValue: user.isAnonymous,
            DBUser.CodingKeys.email.rawValue: user.email,
            DBUser.CodingKeys.photoUrl.rawValue: user.photoUrl
        ]

        try await userDocument(userId: user.userId).updateData(data as [AnyHashable : Any])
        
        
    }
    
    func linkedAnonymousUserToApple(user: DBUser) async throws {
        let data: [String:Any?] = [
            DBUser.CodingKeys.isAnonymous.rawValue: user.isAnonymous,
            DBUser.CodingKeys.email.rawValue: user.email,
            //DBUser.CodingKeys.photoUrl.rawValue: user.photoUrl
        ]

        try await userDocument(userId: user.userId).updateData(data as [AnyHashable : Any])
        
        
    }
    
    func updateUserPremiumStatus(userId: String, isPremium: Bool) async throws {
        let data: [String:Any] = [
            DBUser.CodingKeys.isPremium.rawValue: isPremium
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
}
