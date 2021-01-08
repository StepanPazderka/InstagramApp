//
//  HomeScreenCoordinator.swift
//  InstagramClone_mine
//
//  Created by Štěpán Pazderka on 06.01.2021.
//

import Foundation
import UIKit
import RxSwift

class HomeCoordinator: NavigationCoordinator {    
    var childCoordinators = [Coordinator]()
    var navigation: UINavigationController
    var rootViewController: HomeVC
    
    init(navigationController: UINavigationController, rootViewController: HomeVC) {
        self.navigation = navigationController
        self.rootViewController  = rootViewController
    }
    
    func start() {
        let vc = self.rootViewController
        vc.coordinator = self
        navigation.pushViewController(vc, animated: false)
    }
    
    func showDetailScreen(id: UUID) {
        let DetailScreen = DetailScreenVC()
        DetailScreen.selectedID = id
//        DetailScreen.selectedID = id
//        DetailScreen.delegate = self
        navigation.pushViewController(DetailScreen, animated: true)
    }
}
