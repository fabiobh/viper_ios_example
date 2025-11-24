//
//  SearchRouter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class SearchRouter: SearchPresenterToRouterProtocol {
    
    // MARK: - Static Module Creator
    
    static func createModule() -> UIViewController {
        let view = SearchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        let router = SearchRouter()
        
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
