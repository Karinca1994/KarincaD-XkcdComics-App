//
//  CardView.swift
//  KarincaD-XkcdComics-App
//
//  Created by Karinca Danielsen on 07/10/2022.
//

import SwiftUI

struct CardView: View {
    
    @State var showComic = false
    @State var comic: Comic
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(.black,lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                
            VStack(alignment: .leading) {
                Text(verbatim: "#\(comic.num)")
                    .font(.custom(FontAsset.xkcd.regular, size: 20))
                    .padding()
                
                Text(comic.title)
                    .font(.custom(FontAsset.xkcd.regular, size: 25))
                    .foregroundColor(.black)
                    .padding([.bottom, .horizontal])
                
                ZStack {
                    AsyncImage(url: URL(string: comic.img), content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(50)
                    }, placeholder: {
                        Image("placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding()
                            .frame(height: 400)
                    })
                    
                    VStack {
                        Spacer()
                            .padding(.top)
                        HStack {
                            Spacer()
                            
                            Button {
                                    showComic.toggle()
                            } label: {
                                Image(systemName: "chevron.right.circle")
                                    .resizable()
                                    .foregroundColor(.accentColor)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                                    .padding(10)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width)
        .fullScreenCover(isPresented: $showComic) {
            ComicView(comic: $comic, showComic: $showComic)
        }
    }
}
