//
//  HomeModel.swift
//  Movie
//
//  Created by Apple on 28/04/26.
//
import Foundation
// MARK: - Models
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

struct NowPlayingResponse: Codable {
//    let dates: MovieDates?
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
     //   case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

//struct MovieDates: Codable {
//    let maximum: String
//    let minimum: String
//}

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
struct MoviePayload {
    let nowPlaying: [MovieItem]
}
