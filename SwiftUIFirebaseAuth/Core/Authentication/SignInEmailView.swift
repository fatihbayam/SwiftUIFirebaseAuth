//
//  SignInEmailView.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 13.05.2024.
//

import SwiftUI

struct SignInEmailView: View {
    
    @StateObject private var viewModel = SignInEMailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        
        NavigationStack{
            VStack{
               // image
                Image("firebase-logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height:100)
                    .padding(.vertical, 32)
               // form fields
                VStack(spacing: 24) {
                    TextField("Email...", text: $viewModel.email)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    SecureField("Password...", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top,12)
                
               // sign in button
                Button{
                    Task {
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error.localizedDescription)
                        
                        }
                    }
                    
                } label : {
                    HStack {
                    Text("SIGN IN")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                   }
                .foregroundColor(.white)
                .frame(width:  UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)

                
                Spacer()
               
                // sign up button
                NavigationLink{
                    SignUpEmailView(showSignInView: $showSignInView)
                        .navigationBarBackButtonHidden(true)
                } label : {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size:14))
                }
            }
        }
    }
}


#Preview {
    NavigationStack{
        SignInEmailView(showSignInView: .constant(false))
    }
}


extension SignInEmailView: AuthenticationEmailFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
    }
}
