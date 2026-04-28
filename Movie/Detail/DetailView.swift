//
//  DetailView.swift
//  Movie
//
//  Created by Apple on 24/04/26.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @Binding var selectedAppTab: Int
    @EnvironmentObject private var watchListStore: WatchListStore
    @Environment(\.dismiss) private var dismiss

    init(movie: MovieItem, selectedAppTab: Binding<Int>) {
        self._viewModel = StateObject(wrappedValue: DetailViewModel(movie: movie))
        self._selectedAppTab = selectedAppTab
    }

    var body: some View {
        TabBackground {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    topBar
                    heroSection
                    movieInfo
                    tabSection
                    tabContent
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
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchAccountData()
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Detail")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    watchListStore.toggle(viewModel.movie)
                }
            } label: {
                Image(systemName: watchListStore.contains(viewModel.movie) ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
        .padding(.top, 26)
        .padding(.bottom, 24)
    }

    private var heroSection: some View {
        ZStack(alignment: .bottomTrailing) {
            MovieBackdropView(movie: viewModel.movie)
                .frame(height: 214)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [Color.clear, Color.moviePanel.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            HStack(spacing: 6) {
                Image(systemName: "star")
                    .font(.system(size: 14, weight: .semibold))
                Text(viewModel.movie.rating)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
            .foregroundColor(.orange)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.moviePanel.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding(.trailing, 18)
            .padding(.bottom, 16)
        }
    }

    private var movieInfo: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(alignment: .top, spacing: 16) {
                    MoviePosterView(movie: viewModel.movie)
                        .frame(width: 90, height: 122)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )
                        .clipped()
                        .padding(.top, -58)

                    Text(viewModel.movie.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 16)
                }

                HStack(alignment: .center, spacing: 10) {
                    Spacer()
                        .frame(width: 46)

                    detailMeta(icon: "calendar", text: viewModel.movie.year)
                    metaDivider
                    detailMeta(icon: "clock", text: viewModel.movie.duration)
                    metaDivider
                    detailMeta(icon: "ticket", text: viewModel.movie.genre)
                }
                .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 18)
    }

    private var tabSection: some View {
        HStack(spacing: 28) {
            ForEach(viewModel.tabs, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.selectedInfoTab = tab
                    }
                } label: {
                    VStack(alignment: .center, spacing: 12) {
                        Text(tab)
                            .font(.system(size: 15, weight: viewModel.selectedInfoTab == tab ? .semibold : .medium, design: .rounded))
                            .foregroundColor(viewModel.selectedInfoTab == tab ? .white : .white.opacity(0.72))
                            .frame(maxWidth: .infinity)

                        Capsule()
                            .fill(viewModel.selectedInfoTab == tab ? Color.white.opacity(0.22) : Color.clear)
                            .frame(width: 96, height: 4)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 28)
    }

    private var tabContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            if viewModel.selectedInfoTab == "About Movie" {
                Text(viewModel.movie.overview)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.86))
                    .lineSpacing(6)
            } else if viewModel.selectedInfoTab == "Reviews" {
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(viewModel.reviews) { review in
                        ReviewRow(review: review)
                    }
                }
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 34, alignment: .top),
                        GridItem(.flexible(), spacing: 34, alignment: .top)
                    ],
                    alignment: .center,
                    spacing: 34
                ) {
                    ForEach(viewModel.castMembers) { member in
                        CastMemberCard(member: member)
                    }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 10)
        .padding(.bottom, 36)
    }

    private var metaDivider: some View {
        Rectangle()
            .fill(Color.white.opacity(0.18))
            .frame(width: 1, height: 18)
    }

    private func detailMeta(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.74))
                .frame(width: 14)

            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(.white.opacity(0.78))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

//private struct MovieReview: Identifiable {
//    let id = UUID()
//    let author: String
//    let score: String
//    let body: String
//}
//
//private struct CastMember: Identifiable {
//    let id = UUID()
//    let name: String
//    let imageURL: String
//}

private struct ReviewRow: View {
    let review: MovieReview

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            VStack(spacing: 10) {
                ReviewerAvatar()

                Text(review.score)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color.movieAccent)
            }
            .frame(width: 74)

            VStack(alignment: .leading, spacing: 10) {
                Text(review.author)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)

                Text(review.body)
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct ReviewerAvatar: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(
                    red: 97/255,
                    green: 73/255,
                    blue: 110/255
                ))

            Circle()
                .fill(Color(
                    red: 250/255,
                    green: 214/255,
                    blue: 191/255
                ))
                .frame(width: 20, height: 20)
                .offset(y: -8)

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(
                    red: 49/255,
                    green: 45/255,
                    blue: 67/255
                ))
                .frame(width: 34, height: 24)
                .offset(y: 16)

            Path { path in
                path.move(to: CGPoint(x: 21, y: 31))
                path.addQuadCurve(to: CGPoint(x: 39, y: 31), control: CGPoint(x: 30, y: 24))
            }
            .stroke(
                Color(
                    red: 28/255,
                    green: 45/255,
                    blue: 61/255
                ),
                lineWidth: 5
            )
            .offset(y: -14)
        }
        .frame(width: 58, height: 58)
    }
}

private struct CastMemberCard: View {
    let member: CastMember

    var body: some View {
        VStack(spacing: 14) {
            AsyncImage(url: URL(string: member.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                default:
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))

                        Image(systemName: "person.fill")
                            .font(.system(size: 38, weight: .medium))
                            .foregroundColor(.white.opacity(0.75))
                    }
                }
            }
            .frame(width: 132, height: 132)
            .clipShape(Circle())

            Text(member.name)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DetailView(
        movie: MovieItem(
            tmdbID: 0,
            title: "Spiderman No Way Home",
            rating: "9.5",
            genre: "Action",
            year: "2021",
            duration: "148 Minutes",
            imageName: "chilli",
            backdropName: "tree",
            overview: "From DC Comics comes the Suicide Squad, an antihero team of incarcerated supervillains who act as deniable assets for the United States government, undertaking high-risk black ops missions in exchange for commuted prison sentences."
        ),
        selectedAppTab: .constant(0)
    )
    .environmentObject(WatchListStore())
}
