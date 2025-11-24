//
//  MovieDetailsPresenter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class MovieDetailsPresenter: MovieDetailsViewToPresenterProtocol {
    
    // MARK: - Properties
    weak var view: BasePresenterToViewProtocol?
    var interactor: MovieDetailsPresenterToInteractorProtocol?
    var router: MovieDetailsPresenterToRouterProtocol?
    
    private var movie: Movie
    
    // MARK: - Initialization
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: - View to Presenter
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchMovieDetails(movieId: movie.id)
        
        // Check favorite status
        if let isFavorite = interactor?.checkIfFavorite(movie: movie) {
            (view as? MovieDetailsPresenterToViewProtocol)?.updateFavoriteButton(isFavorite: isFavorite)
        }
    }
    
    func didTapFavorite() {
        interactor?.toggleFavorite(movie: movie)
    }
}

// MARK: - Interactor to Presenter

extension MovieDetailsPresenter: MovieDetailsInteractorToPresenterProtocol {
    func didFetchMovieDetails(_ movie: MovieDetail) {
        view?.hideLoading()
        (view as? MovieDetailsPresenterToViewProtocol)?.showMovieDetails(movie)
    }
    
    func didFailToFetchMovieDetails(with error: String) {
        view?.hideLoading()
        view?.showError(message: error)
    }
    
    func didUpdateFavoriteStatus(isFavorite: Bool) {
        (view as? MovieDetailsPresenterToViewProtocol)?.updateFavoriteButton(isFavorite: isFavorite)
    }
}
