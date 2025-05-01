// RedditAuthManager.swift

import Foundation
import AuthenticationServices
import Combine
import UIKit

class RedditAuthManager: NSObject, ObservableObject {
    @Published var isAuthenticated = false
    @Published var username: String?
    
    private let clientID    = "YOUR_CLIENT_ID"
    private let redirectURI = "myappscheme://oauth"
    private let state       = UUID().uuidString
    private var authSession: ASWebAuthenticationSession?

    func login() {
        let scope   = "identity"
        let authURL = URL(string:
          "https://www.reddit.com/api/v1/authorize.compact?" +
          "client_id=\(clientID)&" +
          "response_type=code&" +
          "state=\(state)&" +
          "redirect_uri=\(redirectURI)&" +
          "duration=permanent&" +
          "scope=\(scope)"
        )!
        
        authSession = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: URL(string: redirectURI)!.scheme
        ) { callbackURL, error in
            guard
                error == nil,
                let callbackURL = callbackURL,
                let comps = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                let items = comps.queryItems,
                let returnedState = items.first(where: { $0.name == "state" })?.value,
                let code = items.first(where: { $0.name == "code" })?.value,
                returnedState == self.state
            else {
                return
            }
            self.exchangeCodeForToken(code)
        }
        
        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = true
        authSession?.start()
    }

    private func exchangeCodeForToken(_ code: String) {
        let tokenURL = URL(string: "https://www.reddit.com/api/v1/access_token")!
        var req = URLRequest(url: tokenURL)
        req.httpMethod = "POST"
        
        let creds = "\(clientID):"
        let basic = Data(creds.utf8).base64EncodedString()
        req.setValue("Basic \(basic)", forHTTPHeaderField: "Authorization")
        req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let body = [
          "grant_type=authorization_code",
          "code=\(code)",
          "redirect_uri=\(redirectURI)"
        ].joined(separator: "&")
        req.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: req) { data, _, _ in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
                let token = json["access_token"] as? String
            else { return }
            
            UserDefaults.standard.set(token, forKey: "access_token")
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.fetchUsername(using: token)
            }
        }.resume()
    }
    
    private func fetchUsername(using token: String) {
        var req = URLRequest(url: URL(string: "https://oauth.reddit.com/api/v1/me")!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: req) { data, _, _ in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
                let name = json["name"] as? String
            else { return }
            
            DispatchQueue.main.async {
                self.username = name
            }
        }.resume()
    }
}

extension RedditAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
