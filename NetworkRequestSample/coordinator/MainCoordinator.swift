//
//  MainCoordinator.swift
//  NetworkRequestSample
//
//  Created by Inam Abbas on 03.12.23.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var dependencies: AppDiContainer
    
    init(navigationController: UINavigationController, dependencies: AppDiContainer) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = PhotoViewModel(photoService: dependencies.photoService)
        viewModel.coordinator = self
        let viewController = PhotoViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
