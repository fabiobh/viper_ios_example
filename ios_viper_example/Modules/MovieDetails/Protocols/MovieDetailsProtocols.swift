//
//  MovieDetailsProtocols.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

// MARK: - View to Presenter
protocol MovieDetailsViewToPresenterProtocol: BaseViewToPresenterProtocol {
    var interactor: MovieDetailsPresenterToInteractorProtocol? { get set }
    var router: MovieDetailsPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapFavorite()
}

// MARK: - Presenter to View
protocol MovieDetailsPresenterToViewProtocol: BasePresenterToViewProtocol {
    func showMovieDetails(_ movie: MovieDetail)
    func updateFavoriteButton(isFavorite: Bool)
}

// MARK: - Presenter to Interactor
protocol MovieDetailsPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    var presenter: MovieDetailsInteractorToPresenterProtocol? { get set }
    
    func fetchMovieDetails(movieId: Int)
    func toggleFavorite(movie: Movie)
    func checkIfFavorite(movie: Movie) -> Bool
}

// MARK: - Interactor to Presenter
protocol MovieDetailsInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func didFetchMovieDetails(_ movie: MovieDetail)
    func didFailToFetchMovieDetails(with error: String)
    func didUpdateFavoriteStatus(isFavorite: Bool)
}

// MARK: - Presenter to Router
protocol MovieDetailsPresenterToRouterProtocol: BasePresenterToRouterProtocol {
}
