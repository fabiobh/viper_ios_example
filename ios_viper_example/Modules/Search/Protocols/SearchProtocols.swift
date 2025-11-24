//
//  SearchProtocols.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

// MARK: - View to Presenter
protocol SearchViewToPresenterProtocol: BaseViewToPresenterProtocol {
    var interactor: SearchPresenterToInteractorProtocol? { get set }
    var router: SearchPresenterToRouterProtocol? { get set }
    
    func searchMovies(query: String)
    func didSelectMovie(at index: Int)
}

// MARK: - Presenter to View
protocol SearchPresenterToViewProtocol: BasePresenterToViewProtocol {
    func showMovies(_ movies: [Movie])
    func showEmptyState()
}

// MARK: - Presenter to Interactor
protocol SearchPresenterToInteractorProtocol: BasePresenterToInteractorProtocol {
    var presenter: SearchInteractorToPresenterProtocol? { get set }
    
    func searchMovies(query: String)
}

// MARK: - Interactor to Presenter
protocol SearchInteractorToPresenterProtocol: BaseInteractorToPresenterProtocol {
    func didFetchMovies(_ movies: [Movie])
    func didFailToFetchMovies(with error: String)
}

// MARK: - Presenter to Router
protocol SearchPresenterToRouterProtocol: BasePresenterToRouterProtocol {
    func navigateToMovieDetails(from view: UIViewController, with movie: Movie)
}
