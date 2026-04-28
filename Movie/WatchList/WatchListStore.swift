//
//  WatchListStore.swift
//  Movie
//
//  Created by Apple on 27/04/26.
//

import Foundation

final class WatchListStore: ObservableObject {
    @Published private(set) var movies: [MovieItem] = []

    func contains(_ movie: MovieItem) -> Bool {
        movies.contains { $0.watchListKey == movie.watchListKey }
    }

    func toggle(_ movie: MovieItem) {
        if let index = movies.firstIndex(where: { $0.watchListKey == movie.watchListKey }) {
            movies.remove(at: index)
        } else {
            movies.append(movie)
        }
    }
}
