//
//  MovieListProtocols.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

// MARK: - View to Presenter
protocol MovieListViewToPresenterProtocol: BaseViewToPresenterProtocol {
    var interactor: MovieListPresenterToInteractorProtocol? { get set }
    var router: MovieListPresenterToRouterProtocol? { get set }
    
    func viewDidLoad()
    func didSelectMovie(at index: Int)
    func loadMoreMovies()
    func refreshMovies()
    func didTapSearch()
    func didTapFavorites()
}

// MARK: - Presenter to View
protocol MovieListPresenterToViewProtocol: BasePresenterToViewProtocol {
    func showMovies(_ movies: [Movie])
    func appendMovies(_ movies: [Movie])
}

// MARK: - Presenter to Interactor
protocol MovieListPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    var presenter: MovieListInteractorToPresenterProtocol? { get set }
    
    func fetchPopularMovies(page: Int)
}

// MARK: - Interactor to Presenter
protocol MovieListInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func didFetchMovies(_ movies: [Movie])
    func didFailToFetchMovies(with error: String)
}

// MARK: - Presenter to Router
protocol MovieListPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func navigateToMovieDetails(from view: UIViewController, with movie: Movie)
    func navigateToSearch(from view: UIViewController)
    func navigateToFavorites(from view: UIViewController)
}
