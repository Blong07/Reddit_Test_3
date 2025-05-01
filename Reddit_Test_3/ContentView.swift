//
//  File2.swift
//  Reddit_Test_2
//
//  Created by Alexander Blong on 29/04/2025.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: RedditAuthManager

    var body: some View {
        VStack(spacing: 40) {
            if authManager.isAuthenticated {
                Text("Welcome, \(authManager.username ?? "Redditor")!")
                    .font(.title2)
            } else {
                Button(action: {
                    authManager.login()
                }) {
                    Text("Log in with Reddit")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
}


