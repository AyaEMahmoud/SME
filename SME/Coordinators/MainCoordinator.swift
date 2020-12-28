//
//  MainCoordinator.swift
//  SME
//
//  Created by Aya Essam on 12/15/20.
//  Copyright © 2020 Aya E Mahmoud. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = CardViewController()
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    
}
