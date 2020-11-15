//
//  MainTabBar.swift
//  InstagramClone_mine
//
//  Created by Steve on 15/11/2020.
//

import UIKit

class MainTabBar: UITabBarController, UITabBarControllerDelegate {

    var HomeScreen = HomeVC(nibName: "HomeVC", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let StreamTab = UINavigationController(rootViewController: HomeScreen)
        StreamTab.navigationBar.topItem?.title = "Home"
        let StreamTabIcon = UITabBarItem(title: "Home", image: UIImage(systemName: "newspaper"), tag: 1)
        StreamTab.tabBarItem = StreamTabIcon
        
        let AddPostTab = AddPostScreenVC(nibName: "AddScreenVC", bundle: nil)
        let AddPostTabIcon = UITabBarItem(title: "Post", image: UIImage(systemName: "plus"), tag: 2)
        AddPostTab.tabBarItem = AddPostTabIcon
        
        let ProfileTab = UINavigationController(rootViewController: ProfileVC(nibName: "ProfileVC", bundle: nil))
        ProfileTab.navigationBar.topItem?.title = "Saved"
        let ProfileTabIcon = UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), tag: 3)
        ProfileTab.tabBarItem = ProfileTabIcon
        
        let controllers = [StreamTab, AddPostTab, ProfileTab]
        self.viewControllers = controllers
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.backgroundColor = .blue
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is AddPostScreenVC {
            let AddPostVC = AddPostScreenVC(nibName: "AddScreenVC", bundle: nil)
            AddPostVC.delegate = self.HomeScreen
            tabBarController.present(AddPostVC, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
}