//
//  TabbarView.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 15.05.2024.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            
            NavigationStack {
                 ProfileView(showSignInView: $showSignInView)
            }
            .tabItem{
                Image(systemName: "person")
                Text("Profile")
            }
            
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
            .tabItem{
                Image(systemName: "gear")
                Text("Settings")
            }

        }
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
