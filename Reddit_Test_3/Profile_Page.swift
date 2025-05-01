import SwiftUI

struct ProfileView: View {
    var username: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome, \(username)")
                .font(.largeTitle)
            Text("This is your profile page.")
        }
        .padding()
    }
}
