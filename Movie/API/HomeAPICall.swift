//
//  APICall.swift
//  Movie
//
//  Created by Apple on 27/04/26.
//

import Foundation

struct TMDBConfigurationResponse: Decodable {
    let images: TMDBImageConfiguration
}

struct TMDBImageConfiguration: Decodable {
    let baseURL: String
    let secureBaseURL: String
    let posterSizes: [String]
    let backdropSizes: [String]

    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case posterSizes = "poster_sizes"
        case backdropSizes = "backdrop_sizes"
    }
}

struct TMDBMovieListResponse: Decodable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Decodable {
    let title: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let genreIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case genreIDs = "genre_ids"
    }
}

enum TMDBAPI {
    private static let bearerToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNDZiYTc5Y2Y2ZTA4OWY5YzI5NjY0MmE3NzE4OGEyZiIsIm5iZiI6MTc3NzI2NzQ3My4xNzEsInN1YiI6IjY5ZWVmMzExMmRlNGU2N2FlYjI4ZTA2NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.1ioYVqRRXRP425rYtTQxKvLQ-aA6OnodN5BVwZ_ZJTw"

    static func fetchConfiguration() async throws -> TMDBConfigurationResponse {
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

        print(String(decoding: data, as: UTF8.self))

        return try JSONDecoder().decode(TMDBConfigurationResponse.self, from: data)
    }

    static func fetchPopularMovies() async throws -> [MovieItem] {
        let configuration = try await fetchConfiguration()

        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1")!
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

        let decoded = try JSONDecoder().decode(TMDBMovieListResponse.self, from: data)
        let posterSize = configuration.images.posterSizes.contains("w500") ? "w500" : (configuration.images.posterSizes.last ?? "original")
        let backdropSize = configuration.images.backdropSizes.contains("w780") ? "w780" : (configuration.images.backdropSizes.last ?? "original")

        return decoded.results.map { movie in
            MovieItem(
                title: movie.title,
                rating: String(format: "%.1f", movie.voteAverage),
                genre: genreName(for: movie.genreIDs.first),
                year: movie.releaseDate.map { String($0.prefix(4)) } ?? "N/A",
                duration: "N/A",
                imageName: "tree",
                backdropName: "tree",
                overview: movie.overview,
                posterURLString: buildImageURL(baseURL: configuration.images.secureBaseURL, size: posterSize, path: movie.posterPath),
                backdropURLString: buildImageURL(baseURL: configuration.images.secureBaseURL, size: backdropSize, path: movie.backdropPath)
            )
        }
    }

    private static func buildImageURL(baseURL: String, size: String, path: String?) -> String? {
        guard let path, !path.isEmpty else { return nil }
        return "\(baseURL)\(size)\(path)"
    }

    private static func genreName(for id: Int?) -> String {
        switch id {
        case 28: return "Action"
        case 12: return "Adventure"
        case 16: return "Animation"
        case 35: return "Comedy"
        case 80: return "Crime"
        case 18: return "Drama"
        case 14: return "Fantasy"
        case 27: return "Horror"
        case 9648: return "Mystery"
        case 10749: return "Romance"
        case 878: return "Sci-Fi"
        case 53: return "Thriller"
        default: return "Movie"
        }
    }
}

// MARK: - Models

struct NowPlayingResponse: Codable {
    let dates: MovieDates
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDates: Codable {
    let maximum: String
    let minimum: String
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let adult: Bool
    let video: Bool
    let originalLanguage: String
    let originalTitle: String
    let genreIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case adult
        case video
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIds = "genre_ids"
    }
}

// MARK: - API Service

struct TMDBService {

    private let bearerToken = "YOUR_BEARER_TOKEN"

    func fetchNowPlaying() async throws -> NowPlayingResponse {

        var components = URLComponents(
            string: "https://api.themoviedb.org/3/movie/now_playing"
        )!

        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(bearerToken)"
        ]

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(NowPlayingResponse.self, from: data)
    }
}

// MARK: - Usage


