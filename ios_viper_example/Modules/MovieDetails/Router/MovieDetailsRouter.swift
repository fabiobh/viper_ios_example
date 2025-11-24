//
//  MovieDetailsRouter.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

class MovieDetailsRouter: MovieDetailsPresenterToRouterProtocol {
    
    // MARK: - Static Module Creator
    
    static func createModule(with movie: Movie) -> UIViewController {
        let view = MovieDetailsViewController()
        let presenter = MovieDetailsPresenter(movie: movie)
        let interactor = MovieDetailsInteractor()
        let router = MovieDetailsRouter()
        
        // Connecting VIPER components
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
}
