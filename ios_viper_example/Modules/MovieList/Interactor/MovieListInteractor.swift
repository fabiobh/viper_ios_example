//
//  MovieListInteractor.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import Foundation

class MovieListInteractor: MovieListPresenterToInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: MovieListInteractorToPresenterProtocol?
    private let networkManager = NetworkManager.shared
    
    // MARK: - Presenter to Interactor
    
    func fetchPopularMovies(page: Int) {
        networkManager.fetchPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.presenter?.didFetchMovies(response.results)
            case .failure(let error):
                self?.presenter?.didFailToFetchMovies(with: error.localizedDescription)
            }
        }
    }
}
