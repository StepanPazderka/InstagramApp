//
//  Coordinator.swift
//  InstagramClone_mine
//
//  Created by Štěpán Pazderka on 05.01.2021.
//

import Foundation
import UIKit

protocol Coordinator {    
    func start()
}

protocol NavigationCoordinator: Coordinator {
    associatedtype UIViewControllerOrInherients
    
    var navigation: UINavigationController { get set }
    var rootViewController: UIViewControllerOrInherients { get set }
}
