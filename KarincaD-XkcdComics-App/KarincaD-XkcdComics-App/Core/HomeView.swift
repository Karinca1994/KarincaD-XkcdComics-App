//
//  HomeView.swift
//  KarincaD-XkcdComics-App
//
//  Created by Karinca Danielsen on 07/10/2022.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var comics: AppApi
    
    @State var main: Bool
    @State var searchText = ""
    @State var isSearching = false
    
    var body: some View {
        NavigationView {
            ScrollView{
                SearchBar(searchText: $searchText, isSearching: $isSearching)
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                ScrollView {
                    VStack {
                    LazyVGrid(columns: [GridItem()]) {
                        ForEach(main ? comics.comics : comics.favorites, id: \.self) { comic in
                            CardView(comic: comic)
                        }
                    }
                        Button {
                            Task {
                                await comics.fetchComics(amount: 10)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(.black,lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                                    
                                Text("Load More...")
                                    .font(.custom(FontAsset.xkcd.regular, size: 20))
                                    .padding()
                            }
                        }
                        .opacity(main ? 1 : 0)
                        .padding()
                }
                    .navigationTitle(main ? "XKCD Comics" : "Favorites")

            }
        }
        .navigationViewStyle(.stack)
    }
        }
}
}

