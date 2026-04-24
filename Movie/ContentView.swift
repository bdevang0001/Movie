//
//  ContentView.swift
//  Movie
//
//  Created by Apple on 23/04/26.
//

import SwiftUI

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            TabView {
//
//                NavigationStack {
//                    Home()
//                }
//                .tabItem {
//                    Label("Home", systemImage: "house.fill")
//                }
//
//                NavigationStack {
//                    SearchView()
//                }
//                .tabItem {
//                    Label("Profile", systemImage: "person.fill")
//                }
//                NavigationStack {
//                    WatchList()
//                }
//                .tabItem {
//                    Label("Messages", systemImage: "message.fill")
//                }
//                .badge(3)
//            }
//        }
//        .padding()
//    }
//}

//#Preview {
//    ContentView()
//}

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack {
            Color.yellow.ignoresSafeArea()
            MainView()

        }
    }
}

#Preview {
    ContentView()
}
