//
//  Home.swift
//  Movie
//
//  Created by Apple on 23/04/26.
//

import SwiftUI

struct Home: View {
    @Binding var selectedTab: Int
    @StateObject private var viewModel = HomeViewModel()

    private let gridColumns = [
        GridItem(.flexible(), spacing: 16, alignment: .top),
        GridItem(.flexible(), spacing: 16, alignment: .top),
        GridItem(.flexible(), spacing: 16, alignment: .top)
    ]

    var body: some View {
        NavigationStack {
            TabBackground {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Home")
                            .font(.system(size: 34, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))

                        VStack(alignment: .leading, spacing: 18) {
                            Text("What do you want to watch?")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                            searchBar
                            featuredCarousel
                            FancySegmentControl(selectedTab: $viewModel.selectedCategory)
                            posterGrid
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 26)
                        .padding(.bottom, 28)
                        .background(
                            RoundedRectangle(cornerRadius: 34, style: .continuous)
                                .fill(Color.moviePanel)
                        )
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadAllData()
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty {
                    Text("Search")
                        .foregroundColor(Color.white.opacity(0.35))
                }

                TextField("", text: $viewModel.searchText)
                    .foregroundColor(.white)
                    .accentColor(Color.movieAccent)
            }
                .autocapitalization(.none)
                .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.white.opacity(0.35))
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.white.opacity(0.32))
            }
        }
        .padding(.horizontal, 18)
        .frame(height: 56)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
    }

    private var featuredCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 22) {
                ForEach(Array(viewModel.activeFeaturedMovies.enumerated()), id: \.element.id) { index, movie in
                    NavigationLink {
                        DetailView(movie: movie, selectedAppTab: $selectedTab)
                    } label: {
                        FeaturedMovieCard(movie: movie, rank: index + 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 18)
        }
        .padding(.horizontal, -14)
        .padding(.bottom, 4)
    }

//    private var posterGrid: some View {
//        LazyVGrid(columns: gridColumns, spacing: 18) {
//            ForEach(visibleMovies) { movie in
//                var movieData:MovieItem = movie
//                if movie.imageName.starts(with: "/") {
//                    
//                    // It's a relative TMDB path
//                    movieData.imageName = "" + movie.imageName
//                } else {
//                    
//                }
//                NavigationLink {
//                    DetailView(movie: movie, selectedAppTab: $selectedTab)
//                } label: {
//                    VStack(alignment: .leading, spacing: 8) {
//                        MoviePosterView(movie: movie)
//                            .frame(width: 96, height: 132)
//                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 18, style: .continuous)
//                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
//                            )
//                            .clipped()
//
//                        Text(movie.title)
//                            .font(.system(size: 12, weight: .medium, design: .rounded))
//                            .foregroundStyle(.white.opacity(0.86))
//                            .lineLimit(1)
//                            .frame(width: 96, alignment: .leading)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .center)
//                }
//                .buttonStyle(.plain)
//            }
//        }
//        .padding(.top, 6)
//    }
    
    
    private var posterGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 18) {
            ForEach(viewModel.visibleMovies) { movie in

                // Create a modified copy instead of mutating inside the ViewBuilder
                let imagePath = movie.imageName.starts(with: "/")
                    ? "https://image.tmdb.org/t/p/w500\(movie.imageName)"
                    : movie.imageName

                let movieData = MovieItem(
                    tmdbID: movie.tmdbID,
                    title: movie.title,
                    rating: movie.rating,
                    genre: movie.genre,
                    year: movie.year,
                    duration: movie.duration,
                    imageName: imagePath,
                    backdropName: movie.backdropName,
                    overview: movie.overview
                )

                NavigationLink {
                    DetailView(
                        movie: movieData,
                        selectedAppTab: $selectedTab
                    )
                } label: {

                    VStack(alignment: .leading, spacing: 8) {

                        MoviePosterView(movie: movieData)
                            .frame(width: 96, height: 132)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 18,
                                    style: .continuous
                                )
                            )
                            .overlay(
                                RoundedRectangle(
                                    cornerRadius: 18,
                                    style: .continuous
                                )
                                .stroke(
                                    Color.white.opacity(0.06),
                                    lineWidth: 1
                                )
                            )
                            .clipped()

                        Text(movieData.title)
                            .font(
                                .system(
                                    size: 12,
                                    weight: .medium,
                                    design: .rounded
                                )
                            )
                            .foregroundStyle(.white.opacity(0.86))
                            .lineLimit(1)
                            .frame(width: 96, alignment: .leading)
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 6)
    }
    
    
    
    
    
    

}

private struct FeaturedMovieCard: View {
    let movie: MovieItem
    let rank: Int

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MoviePosterView(movie: movie)
                .frame(width: 152, height: 222)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.28), radius: 18, x: 0, y: 14)

            Text("\(rank)")
                .font(.system(size: 118, weight: .black, design: .rounded))
                .foregroundStyle(Color.movieAccent)
                .overlay(
                    Text("\(rank)")
                        .font(.system(size: 118, weight: .black, design: .rounded))
                        .foregroundStyle(Color.black)
                        .offset(x: 2, y: 2)
                        .mask(
                            Text("\(rank)")
                                .font(.system(size: 118, weight: .black, design: .rounded))
                        )
                )
                .offset(x: -22, y: 28)
        }
        .frame(width: 176, height: 260, alignment: .topLeading)
    }
}

#Preview {
    Home(selectedTab: .constant(0))
}
