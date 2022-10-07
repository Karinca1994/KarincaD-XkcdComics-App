//
//  Comic.swift
//  KarincaD-XkcdComics-App
//
//  Created by Karinca Danielsen on 07/10/2022.
//


import Foundation

struct Comic: Decodable, Encodable, Hashable {
    var title: String
    var safe_title: String
    let num: Int
    var alt: String
    var news: String?
    var transcript: String?
    var img: String
    var link: String?
    let day: String
    let month: String
    let year: String

    
    func formatDate() -> Date {
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.date(from: "\(day)/\(month)/\(year)")!
    }
    
    func isFavorite(favorites: [Comic]) -> Bool {
        if favorites.contains(where: {$0.num == self.num}) {
            return true
        }
        return false
    }
    
    func returnToHomepage() -> URL {
        URL(string: link ?? "https://xkcd.com/") ?? URL(string: "https://xkcd.com/")!
    }
}

//struct ExpComic: Decodable{
//    let id: Int
//    var explainUrl: String?
//
//}
