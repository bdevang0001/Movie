//
//  MainView.swift
//  Movie
//
//  Created by Apple on 24/04/26.
//
//


import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @StateObject private var watchListStore = WatchListStore()

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(
            red: 32/255,
            green: 38/255,
            blue: 45/255,
            alpha: 0.98
        )
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(
            red: 32/255,
            green: 169/255,
            blue: 255/255,
            alpha: 1.0
        )

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(
                red: 32/255,
                green: 169/255,
                blue: 255/255,
                alpha: 1.0
            )
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(
            red: 124/255,
            green: 129/255,
            blue: 138/255,
            alpha: 1.0
        )
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(
                red: 124/255,
                green: 129/255,
                blue: 138/255,
                alpha: 1.0
            )
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            Home(selectedTab: $selectedTab)
                .tag(0)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            SearchView(selectedTab: $selectedTab)
                .tag(1)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            WatchList(selectedTab: $selectedTab)
                .tag(2)
                .tabItem {
                    Label("Watch list", systemImage: "bookmark")
                }
        }
        .tint(Color.movieAccent)
        .environmentObject(watchListStore)
    }
}

#Preview {
    MainView()
}

struct TabBackground<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color(
                red: 24/255,
                green: 26/255,
                blue: 31/255
            ).ignoresSafeArea()
            content
        }
    }
}

extension Color {
    static let moviePanel = Color(
        red: 38/255,
        green: 45/255,
        blue: 56/255
    )

    static let movieAccent = Color(
        red: 17/255,
        green: 166/255,
        blue: 255/255
    )
}
