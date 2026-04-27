//
//  Home.swift
//  Movie
//
//  Created by Apple on 23/04/26.
//

import SwiftUI

struct Home: View {
    @Binding var selectedTab: Int
    @State private var searchText = ""
    @State private var selectedCategory = "Now playing"
    @State private var tmdbConfigurationLoaded = false
    @State private var popularMovies: [MovieItem] = []

    private let featuredMovies: [MovieItem] = [
        MovieItem(title: "Jurassic World", rating: "7.8", genre: "Sci-Fi", year: "2022", duration: "147 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A new generation faces prehistoric danger when dinosaurs once again disrupt the balance between science and nature."),
        MovieItem(title: "Spider-Man No Way Home", rating: "9.5", genre: "Action", year: "2021", duration: "148 Minutes", imageName: "chilli", backdropName: "tree", overview: "Peter Parker seeks Doctor Strange's help when his identity is revealed, but the spell opens the multiverse and brings unexpected enemies into his world."),
        MovieItem(title: "Fantastic Beasts", rating: "8.2", genre: "Fantasy", year: "2022", duration: "142 Minutes", imageName: "tree", backdropName: "tree", overview: "Newt Scamander joins allies in a magical mission against rising darkness across the wizarding world.")
    ]

    private let sections: [String: [MovieItem]] = [
        "Now playing": [
            MovieItem(title: "Doctor Strange", rating: "8.1", genre: "Fantasy", year: "2022", duration: "126 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "Doctor Strange navigates fractured realities while confronting a threat powerful enough to shatter the multiverse."),
            MovieItem(title: "Fantastic Beasts", rating: "8.2", genre: "Fantasy", year: "2022", duration: "142 Minutes", imageName: "chilli", backdropName: "tree", overview: "Newt and his allies race against time to stop a dangerous plan from taking hold in the magical world."),
            MovieItem(title: "Dog", rating: "7.4", genre: "Comedy", year: "2022", duration: "101 Minutes", imageName: "tree", backdropName: "tree", overview: "A former Army Ranger and a Belgian Malinois travel the Pacific Coast on an emotional and chaotic road trip."),
            MovieItem(title: "Sonic", rating: "7.9", genre: "Adventure", year: "2022", duration: "122 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "Sonic returns with more speed, more heart, and another mission to stop a powerful new threat."),
            MovieItem(title: "Adventure", rating: "7.0", genre: "Adventure", year: "2023", duration: "118 Minutes", imageName: "tree", backdropName: "tree", overview: "A group of unlikely companions sets out on a globe-spanning quest full of danger, humor, and surprises."),
            MovieItem(title: "Avengers", rating: "9.0", genre: "Action", year: "2019", duration: "181 Minutes", imageName: "chilli", backdropName: "chilli", overview: "Earth's mightiest heroes reunite for one last stand to restore hope and reverse a devastating loss.")
        ],
        "Upcoming": [
            MovieItem(title: "Future One", rating: "8.0", genre: "Action", year: "2026", duration: "130 Minutes", imageName: "tree", backdropName: "tree", overview: "A high-stakes futuristic thriller about survival, trust, and the cost of technology."),
            MovieItem(title: "Future Two", rating: "7.9", genre: "Drama", year: "2026", duration: "124 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "An emotional story about ambition, family, and second chances in a rapidly changing world."),
            MovieItem(title: "Future Three", rating: "8.3", genre: "Sci-Fi", year: "2026", duration: "136 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A team ventures into the unknown and discovers more than they ever expected beyond the edge of space."),
            MovieItem(title: "Future Four", rating: "7.8", genre: "Adventure", year: "2026", duration: "128 Minutes", imageName: "tree", backdropName: "tree", overview: "A daring expedition leads to mystery, danger, and a discovery that changes everything."),
            MovieItem(title: "Future Five", rating: "8.1", genre: "Fantasy", year: "2026", duration: "141 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A young hero must master a hidden power before darkness spreads across the kingdom."),
            MovieItem(title: "Future Six", rating: "7.7", genre: "Comedy", year: "2026", duration: "109 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A fast, funny story about misfits thrown into a situation far bigger than they planned for.")
        ],
        "Top rated": [
            MovieItem(title: "Classic One", rating: "9.4", genre: "Drama", year: "2018", duration: "133 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A celebrated drama known for its performances, emotional depth, and unforgettable storytelling."),
            MovieItem(title: "Classic Two", rating: "9.1", genre: "Adventure", year: "2020", duration: "140 Minutes", imageName: "tree", backdropName: "tree", overview: "A fan-favorite adventure that blends spectacle, heart, and a memorable hero's journey."),
            MovieItem(title: "Classic Three", rating: "9.0", genre: "Thriller", year: "2021", duration: "129 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A tense thriller where every clue matters and every choice raises the stakes."),
            MovieItem(title: "Classic Four", rating: "9.2", genre: "Action", year: "2017", duration: "146 Minutes", imageName: "chilli", backdropName: "chilli", overview: "An explosive action blockbuster that still stands out for its scale and emotional payoff."),
            MovieItem(title: "Classic Five", rating: "9.3", genre: "Fantasy", year: "2019", duration: "151 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A richly imagined fantasy epic filled with magic, sacrifice, and legendary battles."),
            MovieItem(title: "Classic Six", rating: "9.0", genre: "Sci-Fi", year: "2020", duration: "138 Minutes", imageName: "tree", backdropName: "tree", overview: "A stylish science-fiction film that mixes big ideas with emotional storytelling.")
        ],
        "Popular": [
            MovieItem(title: "Popular One", rating: "8.8", genre: "Action", year: "2024", duration: "132 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "One of the year's biggest action hits, packed with momentum and crowd-pleasing set pieces."),
            MovieItem(title: "Popular Two", rating: "8.4", genre: "Adventure", year: "2024", duration: "125 Minutes", imageName: "tree", backdropName: "tree", overview: "A vibrant, fast-moving adventure with strong characters and wide appeal."),
            MovieItem(title: "Popular Three", rating: "8.7", genre: "Fantasy", year: "2024", duration: "145 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A visually rich fantasy favorite that captured audiences with its scale and emotion."),
            MovieItem(title: "Popular Four", rating: "8.3", genre: "Comedy", year: "2024", duration: "108 Minutes", imageName: "capsicum", backdropName: "capsicum", overview: "A breakout comedy with sharp timing, lovable characters, and rewatchable energy."),
            MovieItem(title: "Popular Five", rating: "8.5", genre: "Drama", year: "2024", duration: "122 Minutes", imageName: "tree", backdropName: "tree", overview: "A popular drama that resonated with audiences for its grounded storytelling and strong cast."),
            MovieItem(title: "Popular Six", rating: "8.6", genre: "Sci-Fi", year: "2024", duration: "137 Minutes", imageName: "chilli", backdropName: "chilli", overview: "A stylish sci-fi crowd favorite that blends mystery, action, and emotional stakes.")
        ]
    ]

    private var visibleMovies: [MovieItem] {
        if selectedCategory == "Popular", !popularMovies.isEmpty {
            return popularMovies
        }
        return sections[selectedCategory] ?? []
    }

    private var activeFeaturedMovies: [MovieItem] {
        if !popularMovies.isEmpty {
            return Array(popularMovies.prefix(3))
        }
        return featuredMovies
    }

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
                            FancySegmentControl(selectedTab: $selectedCategory)
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
            guard !tmdbConfigurationLoaded else { return }
            tmdbConfigurationLoaded = true
            await loadTMDBConfiguration()
            await loadPopularMovies()
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

            if !searchText.isEmpty {
                Button {
                    searchText = ""
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
                ForEach(Array(activeFeaturedMovies.enumerated()), id: \.element.id) { index, movie in
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

    private var posterGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 18) {
            ForEach(visibleMovies) { movie in
                NavigationLink {
                    DetailView(movie: movie, selectedAppTab: $selectedTab)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        MoviePosterView(movie: movie)
                            .frame(width: 96, height: 132)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                            )
                            .clipped()

                        Text(movie.title)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.86))
                            .lineLimit(1)
                            .frame(width: 96, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 6)
    }

    private func loadTMDBConfiguration() async {
        do {
            popularMovies = try await TMDBAPI.fetchPopularMovies()
            print("Loaded TMDB popular movies: \(popularMovies.count)")
        } catch {
            print("TMDB configuration request failed: \(error.localizedDescription)")
        }
    }
    
    private func loadPopularMovies() async {
        Task {
            do {
                let response = try await TMDBService().fetchNowPlaying()

                print("Page: \(response.page)")
                print("Movies:")

                for movie in response.results {
                    print("- \(movie.title) (\(movie.releaseDate))")
                }

            } catch {
                print("Error:", error)
            }
        }
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
