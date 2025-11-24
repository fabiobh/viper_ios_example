//
//  SearchInteractor.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import Foundation

class SearchInteractor: SearchPresenterToInteractorProtocol {
    
    // MARK: - Properties
    weak var presenter: SearchInteractorToPresenterProtocol?
    private let networkManager = NetworkManager.shared
    
    // MARK: - Presenter to Interactor
    
    func searchMovies(query: String) {
        networkManager.searchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                self?.presenter?.didFetchMovies(response.results)
            case .failure(let error):
                self?.presenter?.didFailToFetchMovies(with: error.localizedDescription)
            }
        }
    }
}
