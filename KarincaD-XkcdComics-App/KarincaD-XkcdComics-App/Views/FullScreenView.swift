//
//  FullScreenView.swift
//  KarincaD-XkcdComics-App
//
//  Created by Karinca Danielsen on 07/10/2022.
//

import SwiftUI

struct FullScreenView: View {
    @Binding var dismiss: Bool
    @Binding var comic: Comic
    @State var scale: CGFloat = 1
    
    var body: some View {
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
            dismiss.toggle()
        }
    }
}

