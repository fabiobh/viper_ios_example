//
//  FavoritesProtocols.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

// MARK: - View to Presenter
protocol FavoritesViewToPresenterProtocol: BaseViewToPresenterProtocol {
    var interactor: FavoritesPresenterToInteractorProtocol? { get set }
    var router: FavoritesPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func viewWillAppear()
    func didSelectMovie(at index: Int)
}

// MARK: - Presenter to View
protocol FavoritesPresenterToViewProtocol: BasePresenterToViewProtocol {
    func showMovies(_ movies: [Movie])
    func showEmptyState()
}

// MARK: - Presenter to Interactor
protocol FavoritesPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    var presenter: FavoritesInteractorToPresenterProtocol? { get set }
    
    func fetchFavorites()
}

// MARK: - Interactor to Presenter
protocol FavoritesInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func didFetchFavorites(_ movies: [Movie])
}

// MARK: - Presenter to Router
protocol FavoritesPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func navigateToMovieDetails(from view: UIViewController, with movie: Movie)
}
