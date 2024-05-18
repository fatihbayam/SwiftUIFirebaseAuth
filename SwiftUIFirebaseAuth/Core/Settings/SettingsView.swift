//
//  SettingsView.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List{
            Button("Logout") {
                Task{
                    do{
                        try viewModel.signOut()
                        showSignInView = true
                    } catch{
                        print("DEBUG: Error signOut \(error.localizedDescription)")
                    }
                }
            }
            
            Button(role: .destructive) {
                Task{
                    do{
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch{
                        print("DEBUG: Error Delete Account \(error.localizedDescription)")
                    }
                }
            } label: {
                    Text("Delete Account")
            }
            
            if viewModel.authProviders.contains(.email){
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous == true {
                anonymousSection
            }
            
        }
        .onAppear{
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}


extension SettingsView {
    private var emailSection: some View{
        Section {
            Button("Reset Password") {
                Task{
                    do{
                        try await viewModel.resetPassword()
                        print("DEBUG: Password Reset!")
                    } catch{
                        print("DEBUG: Error Reset Password.  \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Update Email") {
                Task{
                    do{
                        try await viewModel.updateEmail()
                        print("DEBUG: Update Email!")
                    } catch{
                        print("DEBUG: Error Update Email. \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Update Password") {
                Task{
                    do{
                        try await viewModel.updatePassword()
                        print("DEBUG: Update Password!")
                    } catch{
                        print("DEBUG: Error Update Password. \(error.localizedDescription)")
                    }
                }
            }
            
        } header: {
            Text("Email Functions")
        }
    }
   
    
    private var anonymousSection: some View{
        Section {        
            
            Button("Link Google Account") {
                Task{
                    do{
                        try await viewModel.linkGoogleAccount()
                        print("DEBUG: Google Linked!")
                    } catch{
                        print("DEBUG: Error Google Linked. \(error.localizedDescription)")
                    }
                }
            }
            
            Button("Link Apple Account") {
                Task{
                    do{
                        try await viewModel.linkAppleAccount()
                        print("DEBUG: Apple Linked!")
                    } catch{
                        print("DEBUG: Error Apple Linked. \(error.localizedDescription)")
                    }
                }
            }
            
            ZStack(alignment: .leading) {
                NavigationLink(destination: SignUpEmailView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)
                               ) {
                    EmptyView()
                }
                .opacity(0.0)
                Text("Email Link Account") //This will be the view that you want to display to the user
                    .foregroundColor(.blue)
            }
            
        } header: {
            Text("Create Account")
        }
    }

}
