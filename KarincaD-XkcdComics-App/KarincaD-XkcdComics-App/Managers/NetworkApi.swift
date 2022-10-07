//
//  NetworkApi.swift
//  KarincaD-XkcdComics-App
//
//  Created by Karinca Danielsen on 07/10/2022.
//


import Foundation
import SwiftUI



class AppApi: ObservableObject {

    @Published var comics: [Comic] = []
    @Published var favorites: [Comic] = []
    
    var lastComic: Int = 2681
    var lastComicIsSaved: Int?
    
    init() {
            if let comicsStored = UserDefaults.standard.data(forKey: "comics") {
            print("Found comics")
            lastComic = UserDefaults.standard.integer(forKey: "lastComic")
            lastComicIsSaved = UserDefaults.standard.integer(forKey: "lastComicIsSaved")
            
            do {
                let decodeComics = try JSONDecoder().decode([Comic].self, from: comicsStored)
                comics = decodeComics
                print("Comics loaded.")
                
            } catch {
                print("Error has occured in comics.")
            }
                
                Task {
                let currentLast = await fetchLatest()
                
                if currentLast != lastComic {
                    lastComic = currentLast
                    UserDefaults.standard.set(lastComic, forKey: "lastComic")
                    await showNewst()
                }
            }
            
            if let fav = UserDefaults.standard.data(forKey: "favorites") {
                if let decoded = try? JSONDecoder().decode([Comic].self, from: fav) {
                    favorites = decoded
                } else {
                    print("Error has occured")
                }
            }
            
            
        } else {
            print("Error, no comics was found")
            Task {
                lastComic = await fetchLatest()
                UserDefaults.standard.set(lastComic, forKey: "lastComic")
                await fetchComics(amount: 10)
            }
        }
    }
    
    @MainActor func fetchComics(amount: Int) async {
        var fetchFrom: Int
        var baseUrl = URLComponents(string: "https://xkcd.com/")!
        
        if comics.isEmpty {
            fetchFrom = await fetchLatest()
        } else {
            fetchFrom = lastComicIsSaved!-1
        }
        
        print("Fetching \(amount) comics from \(fetchFrom)")
            for i in (fetchFrom-amount...fetchFrom).reversed() {
            baseUrl.path = "/\(i)/info.0.json"
            
            do {
                let (data, response) = try await URLSession.shared.data(from: baseUrl.url!)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Bad response: \(response)"); return}
     
                if let comic = try? JSONDecoder().decode(Comic.self, from: data) {
                    comics.append(comic)
                    lastComicIsSaved = comic.num
                    UserDefaults.standard.set(lastComicIsSaved, forKey: "lastComicIsSaved")
                    print("Saved comic #\(comic.num)")
                    
                } else {
                    print("an error has occured")
                }
            } catch {
                print(error)
            }
        }
        if let updatedComics = try? JSONEncoder().encode(comics) {
            UserDefaults.standard.set(updatedComics, forKey: "comics")
            print("Saved comics")
            print(comics.map { $0.num })
        } else {
            print("an error has occured")
        }
    }
    
    @MainActor func fetchLatest() async -> Int {
        let baseUrl = URLComponents(string: "https://xkcd.com/info.0.json")!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: baseUrl.url!)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Bad response: \(response)"); return lastComic }
            
            if let comic = try? JSONDecoder().decode(Comic.self, from: data) {
                
                print("Latest comic is: \(comic.num)")
                return comic.num
                
            } else {
                print("an error has occured")
            }
            
        } catch {
            print("Error")
        }
        return lastComic
    }
    
    @MainActor func showNewst() async {
        print("Show newest")
        
        var baseUrl = URLComponents(string: "https://xkcd.com/")!
        
        for (i, comicId) in (comics[0].num...lastComic).reversed().enumerated() {
            baseUrl.path = "/\(comicId)/info.0.json"
            
            do {
                let (data, response) = try await URLSession.shared.data(from: baseUrl.url!)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Bad response: \(response)"); return}
                
                if let comic = try? JSONDecoder().decode(Comic.self, from: data) {
                    comics.insert(comic, at: i)
                    print("Saved comic #\(comic.num) at \(i)")
                    
                } else {
                    print("an error has occured")
                }
            } catch {
                print(error)
            }
        }
        
        if let updatedComics = try? JSONEncoder().encode(comics) {
            UserDefaults.standard.set(updatedComics, forKey: "comics")
            print("Saved comics")
            print(comics.map { $0.num })
        } else {
            print("an error has occured")
        }
    }
    //    @MainActor func fetchExplain() async -> Int {
    //        let baseUrl = URLComponents(string: "https://api.xkcdy.com/comics")!
    //
    //        do {
    //            let (data, response) = try await URLSession.shared.data(from: baseUrl.url!)
    //
    //            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { print("Bad response: \(response)"); return lastComic }
    //
    //            if let expcomic = try? JSONDecoder().decode(ExpComic.self, from: data) {
    //
    //                print("Explain: \(expcomic.id)")
    //                return expcomic.id
    //
    //            } else {
    //                print("an error has occured")
    //            }
    //
    //        } catch {
    //            print("Error")
    //        }
    //        return lastComic
    //    }
    
    func saveToFavorites(comic: Comic) {
        favorites.append(comic)
        
        if let favs = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(favs, forKey: "favorites")
            print("Saved favorites")
            print(favorites.map { $0.num })
        } else {
            print("an error has occured")
        }
    }
    
    func removeFromFavorites(comic: Comic) {
        favorites.removeAll(where: {$0.num == comic.num})
        
        if let favs = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(favs, forKey: "favorites")
            print("Saved favorites")
            print(favorites.map { $0.num })
        } else {
            print("an error has occured")
        }
    }
}



