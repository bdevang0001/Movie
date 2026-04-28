import Foundation
import SwiftUI

class DetailViewModel: ObservableObject {
    let movie: MovieItem
    @Published var selectedInfoTab = "About Movie"
    @Published var accountData: TMDBAccountResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let tabs = ["About Movie", "Reviews", "Cast"]
    
    let reviews: [MovieReview] = [
        MovieReview(
            author: "Iqbal Shafiq Rozaan",
            score: "6.3",
            body: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government."
        ),
        MovieReview(
            author: "Iqbal Shafiq Rozaan",
            score: "6.3",
            body: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government."
        )
    ]
    
    let castMembers: [CastMember] = [
        CastMember(
            name: "Tom Holland",
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/3/33/Tom_Holland_2019_by_Glenn_Francis.jpg"
        ),
        CastMember(
            name: "Zendaya",
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/c/cd/Zendaya_2019_by_Glenn_Francis.jpg"
        ),
        CastMember(
            name: "Benedict Cumberbatch",
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/1/17/Benedict_Cumberbatch_2011.png"
        ),
        CastMember(
            name: "Jacob Batalon",
            imageURL: "https://upload.wikimedia.org/wikipedia/commons/3/32/Jacob_Batalon_by_Gage_Skidmore.jpg"
        )
    ]

    init(movie: MovieItem) {
        self.movie = movie
    }

    @MainActor
    func fetchAccountData() async {
        isLoading = true
        defer { isLoading = false }

        let url = URL(string: "https://api.themoviedb.org/3/account/23059751")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(TMDBAccountResponse.self, from: data)
            self.accountData = decoded
        } catch {
            self.errorMessage = error.localizedDescription
            print("Account fetch failed: \(error)")
        }
    }
}

struct MovieReview: Identifiable {
    let id = UUID()
    let author: String
    let score: String
    let body: String
}

struct CastMember: Identifiable {
    let id = UUID()
    let name: String
    let imageURL: String
}
