//
//  ComicView.swift
//  KarincaD-XkcdComics-App
//
//  Created by Karinca Danielsen on 07/10/2022.
//

import SwiftUI

struct ComicView: View {
    @Binding var comic: Comic
//    @Binding var expcomic: ExpComic
    @Binding var showComic: Bool
    @EnvironmentObject var comics: AppApi

    var body: some View {
        ZStack {
            VStack(spacing:0) {
                ComicContentsView(comic: $comic)
                Spacer()
                Divider()
                ComicFavView(comic: $comic)
            }
            CloseButtonView(showComic: $showComic)
        }
    }
}

struct ComicContentsView: View {
    @Binding var comic: Comic
    @EnvironmentObject var comics: AppApi
    @State var fullImage: Bool = false


    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text(comic.title)
                        .font(.custom(FontAsset.xkcd.regular, size: 25))
                        .padding()
                    
                    Text(verbatim: "#\(comic.num)")
                        .font(.custom(FontAsset.xkcd.regular, size: 20))
                        .padding()
                }
                AsyncImage(url: URL(string: comic.img), content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }, placeholder: {
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                })
                .onTapGesture {
                    fullImage.toggle()
                }
   
                Divider()
                    .padding()
                ContentText(title: "Alt Text", content: comic.alt)
                
                Divider()
                    .padding()

                ContentText(title: "Explanation", content: "Explanation coming soon!")
//              ContentText(title: "Explanation", content: expcomic.alt)
                
                Divider()
                    .padding()
                Text("**Date:** \(comic.formatDate().formatted(date: .abbreviated, time: .omitted))")
                Spacer()
            }
            .padding(.horizontal)
            
        }
        .fullScreenCover(isPresented: $fullImage) {
            FullScreenView(dismiss: $fullImage, comic: $comic)
        }
    }
}

struct ComicFavView: View {
    @EnvironmentObject var comics: AppApi
    @Binding var comic: Comic

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    if comics.comics.firstIndex(of: comic) != 0 {
                        comic = comics.comics.filter({$0.num == comic.num+1})[0]
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10)
            }
            .padding()
            
            Button {
                if comic.isFavorite(favorites: comics.favorites) {
                    comics.removeFromFavorites(comic: comic)
                } else {
                    comics.saveToFavorites(comic: comic)
                }
            } label: {
                Image(systemName: comic.isFavorite(favorites: comics.favorites) ? "heart.fill" : "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
            }
            .padding()
            
            Button {
                withAnimation {
                    if comics.comics.firstIndex(of: comic) != comics.comics.endIndex-1 {
                        comic = comics.comics.filter({$0.num == comic.num-1})[0]
                    }
                    
                }
            } label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10)
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
    }
}

struct CloseButtonView: View {
    @Binding var showComic: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    showComic.toggle()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                }
                .padding()
            }
            
            Spacer()
        }
    }
}

struct ContentText: View {
    @State var title: String
    @State var content: String
//    @State var explainUrl: String

    var body: some View {
        HStack(alignment:.top) {
            Text("\(title): ")
                .bold()
            Text(content)
//            Text(explainUrl)
        }
    }
}

