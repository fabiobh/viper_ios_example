//
//  FavoritesManager.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import Foundation

// MARK: - Favorites Manager

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let favoritesKey = "favorites_movies"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - Public Methods
    
    func getFavorites() -> [Movie] {
        guard let data = userDefaults.data(forKey: favoritesKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let movies = try decoder.decode([Movie].self, from: data)
            return movies
        } catch {
            print("Error decoding favorites: \(error)")
            return []
        }
    }
    
    func addFavorite(_ movie: Movie) {
        var favorites = getFavorites()
        
        // Check if already exists
        if favorites.contains(where: { $0.id == movie.id }) {
            return
        }
        
        favorites.append(movie)
        saveFavorites(favorites)
    }
    
    func removeFavorite(_ movie: Movie) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == movie.id }
        saveFavorites(favorites)
    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(where: { $0.id == movie.id })
    }
    
    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            removeFavorite(movie)
        } else {
            addFavorite(movie)
        }
    }
    
    // MARK: - Private Methods
    
    private func saveFavorites(_ favorites: [Movie]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favorites)
            userDefaults.set(data, forKey: favoritesKey)
        } catch {
            print("Error encoding favorites: \(error)")
        }
    }
}
