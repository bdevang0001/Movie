import Foundation
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText = "" {
        didSet {
            if searchText.count > 2 {
                searchTask?.cancel()
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
                    await searchMovies()
                }
            } else if searchText.isEmpty {
                searchResults = []
            }
        }
    }
    
    @Published var searchResults: [MovieItem] = []
    @Published var isLoading = false
    
    private var searchTask: Task<Void, Never>?

    var filteredMovies: [MovieItem] {
        searchResults
    }

    @MainActor
    func searchMovies() async {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        defer { isLoading = false }

        let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1&query=\(encodedQuery)"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(NowPlayingResponse.self, from: data)
            
            self.searchResults = decoded.results.map { movie in
                MovieItem(
                    tmdbID: movie.id,
                    title: movie.title,
                    rating: String(format: "%.1f", movie.voteAverage),
                    genre: "Action", // TMDB doesn't give names in search, just IDs
                    year: String(movie.releaseDate.prefix(4)),
                    duration: "120 Minutes",
                    imageName: formatImagePath(movie.posterPath),
                    backdropName: formatImagePath(movie.backdropPath),
                    overview: movie.overview
                )
            }
        } catch {
            print("Search failed: \(error)")
        }
    }

    private func formatImagePath(_ path: String?) -> String {
        guard let path = path, !path.isEmpty else { return "" }
        return "https://image.tmdb.org/t/p/w500\(path)"
    }
}
