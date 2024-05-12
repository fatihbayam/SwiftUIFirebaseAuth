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
            
        }
        .onAppear{
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(showSignInView: .constant(false))
}
