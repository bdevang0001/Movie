import Foundation

struct TMDBPersonChangesResponse: Codable {
    let results: [PersonChange]
    let page: Int
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct PersonChange: Codable, Identifiable {
    let id: Int
    let adult: Bool?
}
