//
//  AuthenticationView.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

protocol AuthenticationEmailFormProtocol {
    var formIsValid: Bool { get }
}

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
            
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign In with Email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .standard, state: .normal)) {
                Task {
                    do{
                       try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print("DEBUG: Error sign in with Google \(error.localizedDescription)")
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    AuthenticationView(showSignInView: .constant(false))
}
