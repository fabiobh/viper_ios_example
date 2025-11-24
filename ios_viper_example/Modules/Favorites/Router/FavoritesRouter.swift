//
//  FavoritesRouter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class FavoritesRouter: FavoritesPresenterToRouterProtocol {
    
    // MARK: - Static Module Creator
    
    static func createModule() -> UIViewController {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter()
        let interactor = FavoritesInteractor()
        let router = FavoritesRouter()
        
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
}
