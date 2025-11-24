//
//  FavoritesInteractor.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import Foundation

class FavoritesInteractor: FavoritesPresenterToInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: FavoritesInteractorToPresenterProtocol?
    private let favoritesManager = FavoritesManager.shared
    
    // MARK: - Presenter to Interactor
    
    func fetchFavorites() {
        let favorites = favoritesManager.getFavorites()
        presenter?.didFetchFavorites(favorites)
    }
}
