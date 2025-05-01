//
//  File1.swift
//  Reddit_Test_2
//
//  Created by Alexander Blong on 29/04/2025.
//

// RedditLoginApp.swift

import SwiftUI

@main // @main
struct RedditLoginApp: App {
    @StateObject private var authManager = RedditAuthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}

