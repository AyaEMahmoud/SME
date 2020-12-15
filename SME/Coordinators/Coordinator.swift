//
//  Coordinator.swift
//  SME
//
//  Created by Aya Essam on 12/15/20.
//  Copyright © 2020 Aya E Mahmoud. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
