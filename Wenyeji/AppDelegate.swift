//
//  AppDelegate.swift
//  Wenyeji
//
//  Created by PAC on 2/9/18.
//  Copyright © 2018 PAC. All rights reserved.
//

import UIKit
import SideMenuController
import SVProgressHUD
import IQKeyboardManager
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var user: User?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupGoogleKey()
        setupStuff()
        setNavBar()
        application.statusBarStyle = .lightContent
        
        setupInitialController()
        return true
    }


}
extension AppDelegate {
    
    fileprivate func setupGoogleKey() {
        GMSServices.provideAPIKey("AIzaSyAGYKzU5mf7Zfcs3xgqbYmIpa4HcQKXEWQ")
        GMSPlacesClient.provideAPIKey("AIzaSyAGYKzU5mf7Zfcs3xgqbYmIpa4HcQKXEWQ")
    }
}
extension AppDelegate {
    
    fileprivate func setupInitialController() {
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: AssetName.menu.rawValue)?.withRenderingMode(.alwaysOriginal)
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = SIDE_MENU_WIDTH
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .horizontalPan
        SideMenuController.preferences.animating.transitionAnimator = FadeAnimator.self
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let sideMenuViewController = SideMenuController()
        let homeController = MainTabBarController()
        let navController = UINavigationController(rootViewController: homeController)
        let sideController = SideController()
        
        sideMenuViewController.embed(sideViewController: sideController)
        sideMenuViewController.embed(centerViewController: navController)
        
        window?.rootViewController = sideMenuViewController
    }
}

extension AppDelegate {
    
    fileprivate func setupStuff() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.gradient)
        
        ReachabilityManager.setup()
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }
    
    @objc fileprivate func setNavBar() {
        UINavigationBar.appearance().barTintColor = StyleGuideManager.mainLightBlueBackgroundColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 24)]
    }
}

