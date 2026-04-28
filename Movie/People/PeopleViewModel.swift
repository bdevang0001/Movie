import Foundation
import SwiftUI

class PeopleViewModel: ObservableObject {
    @Published var people: [PersonChange] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @MainActor
    func fetchPeopleChanges() async {
        isLoading = true
        defer { isLoading = false }

        let url = URL(string: "https://api.themoviedb.org/3/person/changes?page=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(TMDBPersonChangesResponse.self, from: data)
            self.people = decoded.results
        } catch {
            self.errorMessage = error.localizedDescription
            print("People changes fetch failed: \(error)")
        }
    }
}
