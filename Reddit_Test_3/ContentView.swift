import SwiftUI

struct ContentView: View {
    @StateObject var authManager = RedditAuthManager()
    @State private var isAccountCreated = false

    var body: some View {
        if isAccountCreated {
            NavigationStack {
                VStack(spacing: 40) {
                    if authManager.isAuthenticated, let name = authManager.username {
                        Text("Hello, \(name)")

                        NavigationLink(destination: ProfileView(username: name)) {
                            Text("Go to Profile Page")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    } else {
                        Button("Log in with Reddit") {
                            authManager.login()
                        }
                    }
                }
                .padding()
            }
            .environmentObject(authManager)
        } else {
            CreateAccountView(isAccountCreated: $isAccountCreated)
        }
    }
}
