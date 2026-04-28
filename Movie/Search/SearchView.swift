//
//  SearchView.swift
//  Movie
//
//  Created by Apple on 23/04/26.
//

import SwiftUI

struct SearchView: View {
    @Binding var selectedTab: Int
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
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
        }
        .navigationBarHidden(true)
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
            if viewModel.filteredMovies.isEmpty {
                emptyState
            } else {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink {
                        DetailView(movie: movie, selectedAppTab: $selectedTab)
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
}

private struct SearchMovieRow: View {
    let movie: MovieItem

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            MoviePosterView(movie: movie)
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
