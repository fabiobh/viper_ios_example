//
//  FavoritesPresenter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class FavoritesPresenter: FavoritesViewToPresenterProtocol {
    
    // MARK: - Properties
    weak var view: BasePresenterToViewProtocol?
    var interactor: FavoritesPresenterToInteractorProtocol?
    var router: FavoritesPresenterToRouterProtocol?
    
    private var movies: [Movie] = []
    
    // MARK: - View to Presenter
    
    func viewDidLoad() {
        loadFavorites()
    }
    
    func viewWillAppear() {
        loadFavorites()
    }
    
    func didSelectMovie(at index: Int) {
        guard index < movies.count,
              let viewController = view as? UIViewController else { return }
        
        let movie = movies[index]
        router?.navigateToMovieDetails(from: viewController, with: movie)
    }
    
    // MARK: - Private Methods
    
    private func loadFavorites() {
        interactor?.fetchFavorites()
    }
}

// MARK: - Interactor to Presenter

extension FavoritesPresenter: FavoritesInteractorToPresenterProtocol {
    func didFetchFavorites(_ movies: [Movie]) {
        self.movies = movies
        
        if movies.isEmpty {
            (view as? FavoritesPresenterToViewProtocol)?.showEmptyState()
        } else {
            (view as? FavoritesPresenterToViewProtocol)?.showMovies(movies)
        }
    }
}
