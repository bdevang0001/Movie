import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var popularMovies: [MovieItem] = []
    @Published var nowPlayingMovies: [MovieItem] = []
    @Published var topRatedMovies: [MovieItem] = []
    @Published var upcomingMovies: [MovieItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var selectedCategory = "Now playing"
    @Published var searchText = "" {
        didSet {
            if searchText.count > 2 {
                searchTask?.cancel()
                searchTask = Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    await searchMovies()
                }
            } else if searchText.isEmpty {
                searchResults = []
            }
        }
    }
    @Published var searchResults: [MovieItem] = []
    @Published var tmdbConfigurationLoaded = false
    
    private var searchTask: Task<Void, Never>?

    private let featuredMovies: [MovieItem] = [
        MovieItem(tmdbID: 0, title: "Jurassic World", rating: "7.8", genre: "Sci-Fi", year: "2022", duration: "147 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A new generation faces prehistoric danger when dinosaurs once again disrupt the balance between science and nature."),
        MovieItem(tmdbID: 0, title: "Spider-Man No Way Home", rating: "9.5", genre: "Action", year: "2021", duration: "148 Minutes", imageName: "chilli", backdropName: "tree", overview: "Peter Parker seeks Doctor Strange's help when his identity is revealed, but the spell opens the multiverse and brings unexpected enemies into his world."),
        MovieItem(tmdbID: 0, title: "Fantastic Beasts", rating: "8.2", genre: "Fantasy", year: "2022", duration: "142 Minutes", imageName: "tree", backdropName: "tree", overview: "Newt Scamander joins allies in a magical mission against rising darkness across the wizarding world.")
    ]

    private let sections: [String: [MovieItem]] = [
        "Now playing": [
            MovieItem(tmdbID: 0, title: "Doctor Strange", rating: "8.1", genre: "Fantasy", year: "2022", duration: "126 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "Doctor Strange navigates fractured realities while confronting a threat powerful enough to shatter the multiverse."),
            MovieItem(tmdbID: 0, title: "Fantastic Beasts", rating: "8.2", genre: "Fantasy", year: "2022", duration: "142 Minutes", imageName: "chilli", backdropName: "tree", overview: "Newt and his allies race against time to stop a dangerous plan from taking hold in the magical world."),
            MovieItem(tmdbID: 0, title: "Dog", rating: "7.4", genre: "Comedy", year: "2022", duration: "101 Minutes", imageName: "tree", backdropName: "tree", overview: "A former Army Ranger and a Belgian Malinois travel the Pacific Coast on an emotional and chaotic road trip."),
            MovieItem(tmdbID: 0, title: "Sonic", rating: "7.9", genre: "Adventure", year: "2022", duration: "122 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "Sonic returns with more speed, more heart, and another mission to stop a powerful new threat."),
            MovieItem(tmdbID: 0, title: "Adventure", rating: "7.0", genre: "Adventure", year: "2023", duration: "118 Minutes", imageName: "tree", backdropName: "tree", overview: "A group of unlikely companions sets out on a globe-spanning quest full of danger, humor, and surprises."),
            MovieItem(tmdbID: 0, title: "Avengers", rating: "9.0", genre: "Action", year: "2019", duration: "181 Minutes", imageName: "chilli", backdropName: "chilli", overview: "Earth's mightiest heroes reunite for one last stand to restore hope and reverse a devastating loss.")
        ],
        "Upcoming": [
            MovieItem(tmdbID: 0, title: "Future One", rating: "8.0", genre: "Action", year: "2026", duration: "130 Minutes", imageName: "tree", backdropName: "tree", overview: "A high-stakes futuristic thriller about survival, trust, and the cost of technology."),
            MovieItem(tmdbID: 0, title: "Future Two", rating: "7.9", genre: "Drama", year: "2026", duration: "124 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "An emotional story about ambition, family, and second chances in a rapidly changing world."),
            MovieItem(tmdbID: 0, title: "Future Three", rating: "8.3", genre: "Sci-Fi", year: "2026", duration: "136 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A team ventures into the unknown and discovers more than they ever expected beyond the edge of space."),
            MovieItem(tmdbID: 0, title: "Future Four", rating: "7.8", genre: "Adventure", year: "2026", duration: "128 Minutes", imageName: "tree", backdropName: "tree", overview: "A daring expedition leads to mystery, danger, and a discovery that changes everything."),
            MovieItem(tmdbID: 0, title: "Future Five", rating: "8.1", genre: "Fantasy", year: "2026", duration: "141 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A young hero must master a hidden power before darkness spreads across the kingdom."),
            MovieItem(tmdbID: 0, title: "Future Six", rating: "7.7", genre: "Comedy", year: "2026", duration: "109 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A fast, funny story about misfits thrown into a situation far bigger than they planned for.")
        ],
        "Top rated": [
            MovieItem(tmdbID: 0, title: "Classic One", rating: "9.4", genre: "Drama", year: "2018", duration: "133 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A celebrated drama known for its performances, emotional depth, and unforgettable storytelling."),
            MovieItem(tmdbID: 0, title: "Classic Two", rating: "9.1", genre: "Adventure", year: "2020", duration: "140 Minutes", imageName: "tree", backdropName: "tree", overview: "A fan-favorite adventure that blends spectacle, heart, and a memorable hero's journey."),
            MovieItem(tmdbID: 0, title: "Classic Three", rating: "9.0", genre: "Thriller", year: "2021", duration: "129 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A tense thriller where every clue matters and every choice raises the stakes."),
            MovieItem(tmdbID: 0, title: "Classic Four", rating: "9.2", genre: "Action", year: "2017", duration: "146 Minutes", imageName: "chilli", backdropName: "chilli", overview: "An explosive action blockbuster that still stands out for its scale and emotional payoff."),
            MovieItem(tmdbID: 0, title: "Classic Five", rating: "9.3", genre: "Fantasy", year: "2019", duration: "151 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A richly imagined fantasy epic filled with magic, sacrifice, and legendary battles."),
            MovieItem(tmdbID: 0, title: "Classic Six", rating: "9.0", genre: "Sci-Fi", year: "2020", duration: "138 Minutes", imageName: "tree", backdropName: "tree", overview: "A stylish science-fiction film that mixes big ideas with emotional storytelling.")
        ],
        "Popular": [
            MovieItem(tmdbID: 0, title: "Popular One", rating: "8.8", genre: "Action", year: "2024", duration: "132 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "One of the year's biggest action hits, packed with momentum and crowd-pleasing set pieces."),
            MovieItem(tmdbID: 0, title: "Popular Two", rating: "8.4", genre: "Adventure", year: "2024", duration: "125 Minutes", imageName: "tree", backdropName: "tree", overview: "A vibrant, fast-moving adventure with strong characters and wide appeal."),
            MovieItem(tmdbID: 0, title: "Popular Three", rating: "8.7", genre: "Fantasy", year: "2024", duration: "145 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A visually rich fantasy favorite that captured audiences with its scale and emotion."),
            MovieItem(tmdbID: 0, title: "Popular Four", rating: "8.3", genre: "Comedy", year: "2024", duration: "108 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A breakout comedy with sharp timing, lovable characters, and rewatchable energy."),
            MovieItem(tmdbID: 0, title: "Popular Five", rating: "8.5", genre: "Drama", year: "2024", duration: "122 Minutes", imageName: "tree", backdropName: "tree", overview: "A popular drama that resonated with audiences for its grounded storytelling and strong cast."),
            MovieItem(tmdbID: 0, title: "Popular Six", rating: "8.6", genre: "Sci-Fi", year: "2024", duration: "137 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A stylish sci-fi crowd favorite that blends mystery, action, and emotional stakes.")
        ]
    ]

    // MARK: - Computed Properties
    
    var visibleMovies: [MovieItem] {
        if !searchText.isEmpty {
            return searchResults
        }
        if selectedCategory == "Popular", !popularMovies.isEmpty {
            return popularMovies
        }
        if selectedCategory == "Top rated", !topRatedMovies.isEmpty {
            return topRatedMovies
        }
        if selectedCategory == "Upcoming", !upcomingMovies.isEmpty {
            return upcomingMovies
        }
        if selectedCategory == "Now playing", !nowPlayingMovies.isEmpty {
            return nowPlayingMovies
        }
        return sections[selectedCategory] ?? []
    }

    var activeFeaturedMovies: [MovieItem] {
        if !searchText.isEmpty {
            return [] // Hide featured when searching
        }
        if !popularMovies.isEmpty {
            return Array(popularMovies.prefix(3))
        }
        return featuredMovies
    }

    func loadAllData() async {
        guard !tmdbConfigurationLoaded else { return }
        tmdbConfigurationLoaded = true
        
        isLoading = true
        defer { isLoading = false }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchNowPlayingMovies() }
            group.addTask { await self.fetchTopRatedMovies() }
            group.addTask { await self.fetchUpcomingMovies() }
            group.addTask { await self.fetchPopularMovies() }
        }
    }

    @MainActor
    func searchMovies() async {
        guard !searchText.isEmpty else { return }
        
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
                    genre: "Action",
                    year: String(movie.releaseDate.prefix(4)),
                    duration: "120 Minutes",
                    imageName: formatImagePath(movie.posterPath),
                    backdropName: formatImagePath(movie.backdropPath),
                    overview: movie.overview
                )
            }
        } catch {
            print("Home search failed: \(error)")
        }
    }

    func fetchNowPlayingMovies() async {
        do {
            let response = try await fetchNowPlaying()
            self.nowPlayingMovies = response.nowPlaying
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func fetchTopRatedMovies() async {
        do {
            let response = try await fetchTopRate()
            self.topRatedMovies = response.nowPlaying
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func fetchUpcomingMovies() async {
        do {
            let response = try await fetchUpcoming()
            self.upcomingMovies = response.nowPlaying
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func fetchPopularMovies() async {
        do {
            let response = try await fetchPopular()
            self.popularMovies = response.nowPlaying
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Private API Methods (originally in the class)
    
    private func fetchConfiguration() async throws -> TMDBConfigurationResponse {
        let url = URL(string: "https://api.themoviedb.org/3/configuration")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200 ..< 300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(TMDBConfigurationResponse.self, from: data)
    }

    private func fetchNowPlaying() async throws -> MoviePayload {
        var request = URLRequest(url: URL(string: "\(baseURLString)now_playing")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(NowPlayingResponse.self, from: data)

        let movieItems = decoded.results.map { movie in
            MovieItem(
                tmdbID: movie.id,
                title: movie.title,
                rating: String(format: "%.1f", movie.voteAverage),
                genre: "Fantasy",
                year: String(movie.releaseDate.prefix(4)),
                duration: "120 Minutes",
                imageName: formatImagePath(movie.posterPath),
                backdropName: formatImagePath(movie.backdropPath),
                overview: movie.overview
            )
        }
        return MoviePayload(nowPlaying: movieItems)
    }

    private func fetchPopular() async throws -> MoviePayload {
        var request = URLRequest(url: URL(string: "\(baseURLString)popular")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(NowPlayingResponse.self, from: data)

        let movieItems = decoded.results.map { movie in
            MovieItem(
                tmdbID: movie.id,
                title: movie.title,
                rating: String(format: "%.1f", movie.voteAverage),
                genre: "Fantasy",
                year: String(movie.releaseDate.prefix(4)),
                duration: "120 Minutes",
                imageName: formatImagePath(movie.posterPath),
                backdropName: formatImagePath(movie.backdropPath),
                overview: movie.overview
            )
        }
        return MoviePayload(nowPlaying: movieItems)
    }

    private func fetchTopRate() async throws -> MoviePayload {
        var request = URLRequest(url: URL(string: "\(baseURLString)top_rated")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(NowPlayingResponse.self, from: data)

        let movieItems = decoded.results.map { movie in
            MovieItem(
                tmdbID: movie.id,
                title: movie.title,
                rating: String(format: "%.1f", movie.voteAverage),
                genre: "Fantasy",
                year: String(movie.releaseDate.prefix(4)),
                duration: "120 Minutes",
                imageName: formatImagePath(movie.posterPath),
                backdropName: formatImagePath(movie.backdropPath),
                overview: movie.overview
            )
        }
        return MoviePayload(nowPlaying: movieItems)
    }

    private func fetchUpcoming() async throws -> MoviePayload {
        var request = URLRequest(url: URL(string: "\(baseURLString)upcoming")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": bearerToken
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(NowPlayingResponse.self, from: data)

        let movieItems = decoded.results.map { movie in
            MovieItem(
                tmdbID: movie.id,
                title: movie.title,
                rating: String(format: "%.1f", movie.voteAverage),
                genre: "Fantasy",
                year: String(movie.releaseDate.prefix(4)),
                duration: "120 Minutes",
                imageName: formatImagePath(movie.posterPath),
                backdropName: formatImagePath(movie.backdropPath),
                overview: movie.overview
            )
        }
        return MoviePayload(nowPlaying: movieItems)
    }

    private func formatImagePath(_ path: String?) -> String {
        guard let path = path, !path.isEmpty else { return "" }
        if path.starts(with: "/") {
            return "https://image.tmdb.org/t/p/w500\(path)"
        }
        return path
    }
}


