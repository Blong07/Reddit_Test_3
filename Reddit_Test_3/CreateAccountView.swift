import SwiftUI

struct CreateAccountView: View {
    @Binding var isAccountCreated: Bool
    @State private var username = "" // states the username
    @State private var password = "" // states the password
    @State private var isPasswordVisible = false
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Create an Account")
                .font(.title)

            TextField("Username", text: $username) // this is where the user will enter the username
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                if isPasswordVisible { // password being visible if
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                   
                }

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                    
                    /* the above section dictates how the password will be visible when the user taps (toggles) the eye icon which makes the password visible/non visible. */
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Create Account") {
                let existingUsernames = UserDefaults.standard.stringArray(forKey: "usernames") ?? []

                let usernamePattern = "^(?=.*[0-9])(?=.*[^A-Za-z0-9]).+$"
                let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernamePattern)

                guard usernamePredicate.evaluate(with: username) else {
                    errorMessage = "Username must include at least one number and one symbol."
                    return
                }

                guard password.count >= 8 else {
                    errorMessage = "Password must be at least 8 characters."
                    return
                }

                guard !existingUsernames.contains(username) else {
                    errorMessage = "Username already taken."
                    return
                }

                // Save new username and password
                var updatedUsernames = existingUsernames
                updatedUsernames.append(username)
                UserDefaults.standard.set(updatedUsernames, forKey: "usernames")
                UserDefaults.standard.set(password, forKey: "password_\(username)")
                UserDefaults.standard.set(true, forKey: "isAccountCreated")
                isAccountCreated = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
