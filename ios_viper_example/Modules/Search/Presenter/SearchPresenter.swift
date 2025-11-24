//
//  SearchPresenter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class SearchPresenter: SearchViewToPresenterProtocol {
    
    // MARK: - Properties
    weak var view: BasePresenterToViewProtocol?
    var interactor: SearchPresenterToInteractorProtocol?
    var router: SearchPresenterToRouterProtocol?
    
    private var movies: [Movie] = []
    
    // MARK: - View to Presenter
    
    func searchMovies(query: String) {
        view?.showLoading()
        interactor?.searchMovies(query: query)
    }
    
    func didSelectMovie(at index: Int) {
        guard index < movies.count,
              let viewController = view as? UIViewController else { return }
        
        let movie = movies[index]
        router?.navigateToMovieDetails(from: viewController, with: movie)
    }
}

// MARK: - Interactor to Presenter

extension SearchPresenter: SearchInteractorToPresenterProtocol {
    func didFetchMovies(_ movies: [Movie]) {
        view?.hideLoading()
        self.movies = movies
        
        if movies.isEmpty {
            (view as? SearchPresenterToViewProtocol)?.showEmptyState()
        } else {
            (view as? SearchPresenterToViewProtocol)?.showMovies(movies)
        }
    }
    
    func didFailToFetchMovies(with error: String) {
        view?.hideLoading()
        view?.showError(message: error)
    }
}
