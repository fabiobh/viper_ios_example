//
//  MovieListPresenter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class MovieListPresenter: MovieListViewToPresenterProtocol {
    
    // MARK: - Properties
    weak var view: BasePresenterToViewProtocol?
    var interactor: MovieListPresenterToInteractorProtocol?
    var router: MovieListPresenterToRouterProtocol?
    
    private var movies: [Movie] = []
    private var currentPage = 1
    private var isLoading = false
    
    // MARK: - View to Presenter
    
    func viewDidLoad() {
        loadMovies()
    }
    
    func didSelectMovie(at index: Int) {
        guard index < movies.count,
              let viewController = view as? UIViewController else { return }
        
        let movie = movies[index]
        router?.navigateToMovieDetails(from: viewController, with: movie)
    }
    
    func loadMoreMovies() {
        guard !isLoading else { return }
        currentPage += 1
        loadMovies(page: currentPage, append: true)
    }
    
    func refreshMovies() {
        currentPage = 1
        movies.removeAll()
        loadMovies()
    }
    
    func didTapSearch() {
        guard let viewController = view as? UIViewController else { return }
        router?.navigateToSearch(from: viewController)
    }
    
    func didTapFavorites() {
        guard let viewController = view as? UIViewController else { return }
        router?.navigateToFavorites(from: viewController)
    }
    
    // MARK: - Private Methods
    
    private func loadMovies(page: Int = 1, append: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        view?.showLoading()
        interactor?.fetchPopularMovies(page: page)
    }
}

// MARK: - Interactor to Presenter

extension MovieListPresenter: MovieListInteractorToPresenterProtocol {
    func didFetchMovies(_ movies: [Movie]) {
        isLoading = false
        view?.hideLoading()
        
        if currentPage == 1 {
            self.movies = movies
            (view as? MovieListPresenterToViewProtocol)?.showMovies(movies)
        } else {
            self.movies.append(contentsOf: movies)
            (view as? MovieListPresenterToViewProtocol)?.appendMovies(movies)
        }
    }
    
    func didFailToFetchMovies(with error: String) {
        isLoading = false
        view?.hideLoading()
        view?.showError(message: error)
    }
}
