//
//  ViperProtocols.swift
//  ios_viper_example
//
//  Created on 2025-11-24.
//

import UIKit

// MARK: - Base VIPER Protocols

/// Protocol for View to Presenter communication
protocol BaseViewToPresenterProtocol: AnyObject {
    var view: BasePresenterToViewProtocol? { get set }
}

/// Protocol for Presenter to View communication
protocol BasePresenterToViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
}

/// Protocol for Presenter to Interactor communication
protocol BasePresenterToInteractorProtocol: AnyObject {
}

/// Protocol for Interactor to Presenter communication
protocol BaseInteractorToPresenterProtocol: AnyObject {
}

/// Protocol for Presenter to Router communication
protocol BasePresenterToRouterProtocol: AnyObject {
}
