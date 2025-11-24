//
//  MovieListRouter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class MovieListRouter: MovieListPresenterToRouterProtocol {
    
    // MARK: - Static Module Creator
    
    static func createModule() -> UIViewController {
        let view = MovieListViewController()
        let presenter = MovieListPresenter()
        let interactor = MovieListInteractor()
        let router = MovieListRouter()
        
        // Connecting VIPER components
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    // MARK: - Presenter to Router
    
    func navigateToMovieDetails(from view: UIViewController, with movie: Movie) {
        let detailsModule = MovieDetailsRouter.createModule(with: movie)
        view.navigationController?.pushViewController(detailsModule, animated: true)
    }
    
    func navigateToSearch(from view: UIViewController) {
        let searchModule = SearchRouter.createModule()
        view.navigationController?.pushViewController(searchModule, animated: true)
    }
    
    func navigateToFavorites(from view: UIViewController) {
        let favoritesModule = FavoritesRouter.createModule()
        view.navigationController?.pushViewController(favoritesModule, animated: true)
    }
}
