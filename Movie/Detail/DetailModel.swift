import Foundation

struct TMDBAccountResponse: Codable {
    let avatar: Avatar
    let id: Int
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let includeAdult: Bool
    let username: String

    enum CodingKeys: String, CodingKey {
        case avatar, id, name, username
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case includeAdult = "include_adult"
    }
}

struct Avatar: Codable {
    let gravatar: Gravatar
    let tmdb: TMDBAvatar
}

struct Gravatar: Codable {
    let hash: String
}

struct TMDBAvatar: Codable {
    let avatarPath: String?

    enum CodingKeys: String, CodingKey {
        case avatarPath = "avatar_path"
    }
}
