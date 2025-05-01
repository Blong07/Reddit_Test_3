import SwiftUI

struct SubredditSelectionView: View {
    @State private var selectedSubreddits: Set<String> = []
    @State private var subredditInput = ""
    @ObservedObject var authManager: RedditAuthManager

    var body: some View {
        VStack {
            Text("Select up to 4 Subreddits")
                .font(.headline)
                .padding()

            TextField("Enter subreddit (no r/)", text: $subredditInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Subreddit") {
                let trimmed = subredditInput.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty && selectedSubreddits.count < 4 {
                    selectedSubreddits.insert(trimmed)
                    subredditInput = ""
                }
            }
            .disabled(selectedSubreddits.count >= 4)

            List(Array(selectedSubreddits), id: \.self) { subreddit in
                HStack {
                    Text("r/\(subreddit)")
                    Spacer()
                    Button(action: {
                        selectedSubreddits.remove(subreddit)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }

            Spacer()

            Button("Continue") {
                UserDefaults.standard.set(Array(selectedSubreddits), forKey: "selected_subreddits")
            }
            .disabled(selectedSubreddits.isEmpty)
            .padding()
        }
        .padding()
    }
}

struct SubredditSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SubredditSelectionView(authManager: RedditAuthManager())
    }
}

