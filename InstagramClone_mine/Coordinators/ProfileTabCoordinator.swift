//
//  ProfileTabCoordinator.swift
//  InstagramClone_mine
//
//  Created by Štěpán Pazderka on 07.01.2021.
//

import Foundation
import UIKit

class ProfileTabCoordinator: NavigationCoordinator {
    var navigation: UINavigationController = UINavigationController()
    var rootViewController: ProfileVC
    
    init(rootViewController: ProfileVC) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let profileVC = self.rootViewController
        profileVC.coordinator = self
    }
    
    
}
