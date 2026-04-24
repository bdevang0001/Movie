//
//  SearchView.swift
//  Movie
//
//  Created by Apple on 23/04/26.
//

import SwiftUI

struct SearchView: View {
    @Binding var selectedTab: Int
    @State private var searchText = "Spiderman"
    @State private var selectedMovie: MovieItem?

    private let allMovies: [MovieItem] = [
        MovieItem(
            title: "Spiderman",
            rating: "9.5",
            genre: "Action",
            year: "2019",
            duration: "139 minutes",
            imageName: "capsicum",
            backdropName: "capsicum",
            overview: "Peter Parker balances his student life with the responsibility of protecting New York from dangerous new threats."
        ),
        MovieItem(
            title: "Spider-Man No Way Home",
            rating: "9.5",
            genre: "Action",
            year: "2021",
            duration: "148 Minutes",
            imageName: "tree",
            backdropName: "tree",
            overview: "Peter Parker seeks Doctor Strange's help after his identity is exposed, but the spell fractures the multiverse and unleashes chaos."
        ),
        MovieItem(
            title: "Doctor Strange",
            rating: "8.1",
            genre: "Fantasy",
            year: "2022",
            duration: "126 Minutes",
            imageName: "chilli",
            backdropName: "chilli",
            overview: "Doctor Strange navigates new dimensions and impossible odds while confronting a force that threatens reality itself."
        ),
        MovieItem(
            title: "Avengers Endgame",
            rating: "9.0",
            genre: "Adventure",
            year: "2019",
            duration: "181 Minutes",
            imageName: "tree",
            backdropName: "tree",
            overview: "The Avengers gather one last time to undo their greatest defeat and restore hope to the universe."
        ),
        MovieItem(
            title: "Jurassic World",
            rating: "7.8",
            genre: "Sci-Fi",
            year: "2022",
            duration: "147 Minutes",
            imageName: "capsicum",
            backdropName: "capsicum",
            overview: "Humans and dinosaurs must coexist in a world forever changed by scientific ambition and prehistoric power."
        )
    ]

    private var filteredMovies: [MovieItem] {
        let query = normalized(searchText)

        if query.isEmpty {
            return allMovies
        }

        return allMovies.filter { movie in
            normalized(movie.title).contains(query)
                || normalized(movie.genre).contains(query)
                || movie.year.contains(query)
        }
    }

    var body: some View {
        TabBackground {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Search")
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.9))

                    VStack(alignment: .leading, spacing: 28) {
                        topBar
                        searchBar
                        resultsList
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 26)
                    .padding(.bottom, 40)
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
        .fullScreenCover(item: $selectedMovie) { movie in
            DetailView(movie: movie) {
                selectedMovie = nil
                selectedTab = 0
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                selectedTab = 0
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Search")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "clock")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 34, height: 34)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text("Search")
                        .foregroundColor(Color.white.opacity(0.35))
                }

                TextField("", text: $searchText)
                    .foregroundColor(.white)
                    .accentColor(Color.movieAccent)
            }
            .autocapitalization(.none)
            .autocorrectionDisabled()

            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.white.opacity(0.32))
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

    private var resultsList: some View {
        VStack(alignment: .leading, spacing: 28) {
            if filteredMovies.isEmpty {
                emptyState
            } else {
                ForEach(filteredMovies) { movie in
                    Button {
                        selectedMovie = movie
                    } label: {
                        SearchMovieRow(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 58, height: 58)

                Circle()
                    .fill(Color.moviePanel)
                    .frame(width: 44, height: 44)

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)

                Circle()
                    .fill(Color.movieAccent)
                    .frame(width: 16, height: 16)
                    .offset(x: -22, y: -12)

                Circle()
                    .fill(Color.movieAccent)
                    .frame(width: 18, height: 18)
                    .offset(x: 20, y: 16)
            }
            .padding(.bottom, 6)

            Text("We Are Sorry, We Can Not Find The Movie :(")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Find your movie by Type title,\ncategories, years, etc")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 120)
    }

    private func normalized(_ value: String) -> String {
        value
            .lowercased()
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}

private struct SearchMovieRow: View {
    let movie: MovieItem

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(movie.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 94, height: 116)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                .clipped()

            VStack(alignment: .leading, spacing: 9) {
                Text(movie.title)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Label(movie.rating, systemImage: "star")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.orange)

                SearchMetaRow(icon: "ticket", text: movie.genre)
                SearchMetaRow(icon: "calendar", text: movie.year)
                SearchMetaRow(icon: "clock", text: movie.duration)
            }
            .padding(.top, 2)

            Spacer(minLength: 0)
        }
    }
}

private struct SearchMetaRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.82))
                .frame(width: 14)

            Text(text)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.86))
        }
    }
}

#Preview {
    SearchView(selectedTab: .constant(1))
}
