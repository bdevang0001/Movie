//
//  WatchList.swift
//  Movie
//
//  Created by Apple on 23/04/26.
//

import SwiftUI

struct WatchList: View {
    @Binding var selectedTab: Int
    @EnvironmentObject private var watchListStore: WatchListStore
    @StateObject private var viewModel: WatchListViewModel

    init(selectedTab: Binding<Int>, watchListStore: WatchListStore? = nil) {
        self._selectedTab = selectedTab
        // In actual usage, the store will be passed or retrieved from environment
        // For simplicity in the view, we can use a StateObject that we initialize in the body or init
        self._viewModel = StateObject(wrappedValue: WatchListViewModel(watchListStore: watchListStore ?? WatchListStore()))
    }

    var body: some View {
        TabBackground {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    topBar

                    if viewModel.movies.isEmpty {
                        emptyState
                    } else {
                        VStack(alignment: .leading, spacing: 28) {
                            ForEach(viewModel.movies) { movie in
                                WatchListRow(movie: movie)
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 26)
                        .padding(.bottom, 120)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .fill(Color.moviePanel)
                )
                .padding(.horizontal, 18)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                selectedTab = 0
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Watch list")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            Spacer()

            Color.clear
                .frame(width: 34, height: 34)
        }
        .padding(.horizontal, 32)
        .padding(.top, 26)
        .padding(.bottom, 24)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            ZStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.orange)
                    .offset(x: 1, y: -34)

                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 54, weight: .medium))
                    .foregroundColor(Color.movieAccent)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 170)

            Text("There Is No Movie Yet!")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            Text("Find your movie by Type title,\ncategories, years, etc")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.45))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
        .padding(.bottom, 220)
    }
}

private struct WatchListRow: View {
    let movie: MovieItem

    var body: some View {
        HStack(alignment: .top, spacing: 22) {
            MoviePosterView(movie: movie)
                .frame(width: 88, height: 116)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
                .clipped()

            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)

                HStack(spacing: 8) {
                    Image(systemName: "star")
                        .font(.system(size: 14, weight: .medium))
                    Text(movie.rating)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                }
                .foregroundColor(.orange)
                .padding(.top, 2)

                watchMeta(icon: "ticket", text: movie.genre)
                watchMeta(icon: "calendar", text: movie.year)
                watchMeta(icon: "clock", text: movie.duration)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 4)
        }
    }

    private func watchMeta(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.white)
                .frame(width: 16)

            Text(text)
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.92))
        }
    }
}

#Preview {
    WatchList(selectedTab: .constant(2))
        .environmentObject(WatchListStore())
}
