//
//  MovieDetailsInteractor.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import Foundation

class MovieDetailsInteractor: MovieDetailsPresenterToInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: MovieDetailsInteractorToPresenterProtocol?
    private let networkManager = NetworkManager.shared
    private let favoritesManager = FavoritesManager.shared
    
    // MARK: - Presenter to Interactor
    
    func fetchMovieDetails(movieId: Int) {
        networkManager.fetchMovieDetails(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.presenter?.didFetchMovieDetails(movie)
            case .failure(let error):
                self?.presenter?.didFailToFetchMovieDetails(with: error.localizedDescription)
            }
        }
    }
    
    func toggleFavorite(movie: Movie) {
        favoritesManager.toggleFavorite(movie)
        let isFavorite = favoritesManager.isFavorite(movie)
        presenter?.didUpdateFavoriteStatus(isFavorite: isFavorite)
    }
    
    func checkIfFavorite(movie: Movie) -> Bool {
        return favoritesManager.isFavorite(movie)
    }
}
