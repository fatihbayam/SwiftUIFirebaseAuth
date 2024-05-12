//
//  AuthenticationView.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import SwiftUI

struct AuthenticationView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            
            Button(action: {
                Task {
                    do{
                       try await viewModel.signInAnonymous()
                        showSignInView = false
                    } catch {
                        print("DEBUG: Error sign in with Anonymous \(error.localizedDescription)")
                    }
                }
            }, label: {
                Text("Sign In Anonymously")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.orange)
                    .cornerRadius(10)
            })
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
