//
//  MovieItem.swift
//  Movie
//
//  Created by Apple on 24/04/26.
//

import Foundation

struct MovieItem: Identifiable, Hashable {
    let id = UUID()
    let tmdbID: Int
    let title: String
    let rating: String
    let genre: String
    let year: String
    let duration: String
    var imageName: String
    let backdropName: String
    let overview: String
    let posterURLString: String?
    let backdropURLString: String?

    init(
        tmdbID: Int,
        title: String,
        rating: String,
        genre: String,
        year: String,
        duration: String,
        imageName: String,
        backdropName: String,
        overview: String,
        posterURLString: String? = nil,
        backdropURLString: String? = nil
    ) {
        self.tmdbID = tmdbID
        self.title = title
        self.rating = rating
        self.genre = genre
        self.year = year
        self.duration = duration
        self.imageName = imageName
        self.backdropName = backdropName
        self.overview = overview
        self.posterURLString = posterURLString
        self.backdropURLString = backdropURLString
    }

    var watchListKey: String {
        "\(title.lowercased())-\(year)-\((posterURLString ?? imageName).lowercased())"
    }
}
