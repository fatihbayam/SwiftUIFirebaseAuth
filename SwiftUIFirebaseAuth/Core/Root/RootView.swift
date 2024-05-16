//
//  MainView.swift
//  SwiftUIFirebaseAuth
//
//  Created by Fatih Bayam on 12.05.2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        
        ZStack{
            if !showSignInView {
                NavigationStack{
                    ProfileView(showSignInView: $showSignInView)
                }
            }

        }
        .onAppear(){
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        })
    }
}

#Preview {
    MainView()
}
