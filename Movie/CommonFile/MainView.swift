//
//  MainView.swift
//  Movie
//
//  Created by Apple on 24/04/26.
//
//


import SwiftUI

struct MainView: View {
    let color = Color.clear
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        // your tab bar bg
     
        // Selected (active tab)
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        appearance.stackedLayoutAppearance.selected.iconColor =  UIColor(
            red: 32/255,
            green: 96/255,
            blue: 140/255,
            alpha: 1.0
        )

        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(
                red: 32/255,
                green: 96/255,
                blue: 140/255,
                alpha: 1.0
            )
        ]
     
        // Unselected (inactive tabs)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(
                red: 95/255,
                green: 96/255,
                blue: 101/255,
                alpha: 1.0
            )
        ]
     
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        TabView {
            Home( )
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            SearchView( )
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            WatchList( )
                .tabItem {
                    Label("watchlist", systemImage: "bookmark.fill")
                }

        }.tint(.black)
    }
}

#Preview {
    MainView()
        .background(Color.red)
}

struct TabBackground<Content: View>: View {
    let content: Content
 
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
 
    var body: some View {
        ZStack {
            //Color.blue.ignoresSafeArea()
            Color(
                red: 36/255,
                green: 42/255,
                blue: 50/255
            ).ignoresSafeArea()
            content
        }
    }
}

