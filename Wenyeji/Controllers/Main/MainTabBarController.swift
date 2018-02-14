//
//  MainTabBarController.swift
//  Wenyeji
//
//  Created by PAC on 2/9/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if !isLoggedIn() {
            perform(#selector(showLoginController), with: nil, afterDelay: 0)
            
            return
        }
        
        setupViewControllers()
    }
}

extension MainTabBarController {
    
    @objc fileprivate func showLoginController() {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        present(navController, animated: true, completion: {
        })
        
        
    }
    
    fileprivate func isLoggedIn() -> Bool {
        
        return UserDefaults.standard.isLoggedIn()
    }
}

extension MainTabBarController {
    func setupViewControllers() {
        
        let postsController = PostsController()
        postsController.view.backgroundColor = .white
        postsController.tabBarItem.title = "Posts"
        postsController.tabBarItem.image = UIImage(named: AssetName.postFeed.rawValue)
        
        let myPostsController = MyPostsController()
        myPostsController.view.backgroundColor = .white
        myPostsController.tabBarItem.title = "My Posts"
         myPostsController.tabBarItem.image = UIImage(named: AssetName.star.rawValue)
        
        let likedPostsController = UIViewController()
        likedPostsController.view.backgroundColor = .white
        likedPostsController.tabBarItem.title = "Like"
        likedPostsController.tabBarItem.image = UIImage(named: AssetName.heart.rawValue)
        
        tabBar.tintColor = .black
        
        viewControllers = [postsController,
                           myPostsController,
                           likedPostsController]
        
        // modify tab bar items insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
