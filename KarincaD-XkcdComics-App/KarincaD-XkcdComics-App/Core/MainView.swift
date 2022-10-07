//
//  ContentView.swift
//  KarincaD-XkcdComics-App
//
//  Created by Karinca Danielsen on 07/10/2022.
//

import SwiftUI

struct MainView: View {
    @StateObject var comics = AppApi()
    
    var body: some View {
        TabView {
            HomeView(main: true)
                .tabItem {
                    Label("Browse", systemImage: "eye")
                }
            HomeView(main: false)
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            HomeView(main: false)
                .tabItem {
                    Label("Seach", systemImage: "magnifyingglass")
                }
            

        }
        .environmentObject(comics)
        
    }
}
