//
//  MovieArtworkView.swift
//  Movie
//
//  Created by Apple on 27/04/26.
//

import SwiftUI

//struct MoviePosterView: View {
//    let movie: MovieItem
//
//    var body: some View {
//        if let posterURLString = movie.posterURLString,
//           let url = URL(string: posterURLString) {
//            AsyncImage(url: url) { phase in
//                switch phase {
//                case .success(let image):
//                    image
//                        .resizable()
//                        .scaledToFill()
//                default:
//                    fallbackPoster
//                }
//            }
//        } else {
//            fallbackPoster
//        }
//    }
//
//    private var fallbackPoster: some View {
//        Image(movie.imageName)
//            .resizable()
//            .scaledToFill()
//    }
//}

struct MoviePosterView: View {
    let movie: MovieItem

    var body: some View {

        if movie.imageName.starts(with: "http"),
           let url = URL(string: movie.imageName) {

            AsyncImage(url: url) { phase in
                switch phase {

                case .empty:
                    ProgressView()

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()

                @unknown default:
                    EmptyView()
                }
            }

        } else {

            // Fallback for asset catalog images like "capsicum"
            Image(movie.imageName)
                .resizable()
                .scaledToFill()
        }
    }
}

struct MovieBackdropView: View {
    let movie: MovieItem

    var body: some View {
        if movie.backdropName.starts(with: "http"),
           let url = URL(string: movie.backdropName) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    fallbackBackdrop
                }
            }
        } else {
            fallbackBackdrop
        }
    }

    private var fallbackBackdrop: some View {
        Image(movie.backdropName)
            .resizable()
            .scaledToFill()
    }
}
