import SwiftUI

struct TopPostsView: View {
    let subreddits: [String]
    @State private var topPosts: [String: String] = [:]

    var body: some View {
        List(subreddits, id: \.self) { subreddit in
            VStack(alignment: .leading) {
                Text("r/\(subreddit)")
                    .font(.headline)
                if let post = topPosts[subreddit] {
                    if let url = URL(string: "https://www.reddit.com/r/\(subreddit)") {
                        Link(destination: url) {
                            Text(post)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .underline()
                        }
                    }
                    
                } else {
                    Text("Loading...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .onAppear {
            fetchTopPosts()
        }
        .navigationTitle("Top Posts")
    }

    private func fetchTopPosts() {
        for subreddit in subreddits {
            guard let url = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=1&t=day") else { continue }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let dataDict = json["data"] as? [String: Any],
                    let children = dataDict["children"] as? [[String: Any]],
                    let firstPost = children.first,
                    let postData = firstPost["data"] as? [String: Any],
                    let title = postData["title"] as? String
                else {
                    return
                }

                DispatchQueue.main.async {
                    topPosts[subreddit] = title
                }
            }

            task.resume()
        }
    }
}

struct TopPostsView_Previews: PreviewProvider {
    static var previews: some View {
        TopPostsView(subreddits: ["news", "technology", "swift", "apple"])
    }
}
