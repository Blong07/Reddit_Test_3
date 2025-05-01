import SwiftUI

struct CreateAccountView: View {
    @Binding var isAccountCreated: Bool
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Create an Account")
                .font(.title)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Create Account") {
                let existingUsernames = UserDefaults.standard.stringArray(forKey: "usernames") ?? []

                guard password.count >= 8 else { // ensures password consists of 8 characters
                    print("Password must be at least 8 characters long.")
                    return
                }

                guard !existingUsernames.contains(username) else {
                    print("Username already exists.")
                    return
                }

                // Save new username and password (basic demonstration; use secure storage for real apps)
                var updatedUsernames = existingUsernames
                updatedUsernames.append(username)
                UserDefaults.standard.set(updatedUsernames, forKey: "usernames")
                UserDefaults.standard.set(password, forKey: "password_\(username)")
                UserDefaults.standard.set(true, forKey: "isAccountCreated")
                isAccountCreated = true
                
                /* UserDefaults stores all pre-existing usernames to prevent users from creating similar usernames. This is important as if a user were to use the same username, there's a possibility they will also use the same password and accidentally log into the same account!*/
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
