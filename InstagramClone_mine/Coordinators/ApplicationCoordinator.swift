//
//  ApplicationCoordinator.swift
//  InstagramClone_mine
//
//  Created by Štěpán Pazderka on 06.01.2021.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    var window: UIWindow
    var rootViewController: MainTabBar
    
    init(window: UIWindow) {
      self.window = window
      rootViewController = MainTabBar()
    }
    
    func start() {
        window.rootViewController = MainTabBar()
        window.makeKeyAndVisible()
    }
}
