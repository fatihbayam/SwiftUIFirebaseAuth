//
//  SignUpEmailView.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 16.05.2024.
//

import SwiftUI

struct SignUpEmailView: View {
    
    @StateObject private var viewModel = SignUpEMailViewModel()
    @Binding var showSignInView: Bool
    
    @Environment(\.dismiss) var dismiss  // for go back screen
    
    var body: some View {
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
                 
                 ZStack (alignment: .trailing) {
                     SecureField("Confirm Password...", text: $viewModel.confirmPassword)
                         .padding()
                         .background(Color.gray.opacity(0.4))
                         .cornerRadius(10)
                     
                     if !viewModel.password.isEmpty && !viewModel.confirmPassword.isEmpty {
                         if viewModel.password == viewModel.confirmPassword {
                             Image(systemName: "checkmark.circle.fill")
                                 .imageScale(.large)
                                 .fontWeight(.bold)
                                 .foregroundColor(Color(.systemGreen))
                         } else {
                             Image(systemName: "xmark.circle.fill")
                                 .imageScale(.large)
                                 .fontWeight(.bold)
                                 .foregroundColor(Color(.systemRed))
                         }
                     }
                     
                 }
             }
             .padding(.horizontal)
             .padding(.top,12)
            
            // sign up button
            Button{
                Task {
                        do {
                            try await viewModel.createNewUser()
                            showSignInView = false
                            dismiss()
                            return
                           } catch {
                                print(error.localizedDescription)
                
                        }
                }
            } label : {HStack {
                Text("SIGN UP")
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
            
            Button {
                dismiss()
            } label : {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                }
                .font(.system(size:14))
            }
        }
        .task {
            try? await viewModel.loadAuthUser()
        }
    }
}

#Preview {
    SignUpEmailView(showSignInView: .constant(false))
}


extension SignUpEmailView: AuthenticationEmailFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
        && viewModel.confirmPassword == viewModel.password
    }
}
