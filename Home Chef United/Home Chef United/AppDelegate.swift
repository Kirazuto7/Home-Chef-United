//
//  AppDelegate.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/15/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(applicationDocumentsDirectory)
        // Override point for customization after application launch.
        FirebaseApp.configure()
        setupNavigationBar()
        UITabBar.appearance().backgroundColor = appBackgroundColor
        UITabBar.appearance().barTintColor = appBackgroundColor
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Helper Methods
    
    func setupNavigationBar() {
        // SOURCE: - https://stackoverflow.com/questions/24687238/changing-navigation-bar-color-in-swift
        let navigation = UINavigationBar.appearance()
        navigation.backgroundColor = appBackgroundColor
        let backImage = UIImage(systemName: "arrow.backward")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .heavy))
        navigation.backIndicatorImage = backImage
        navigation.backIndicatorTransitionMaskImage = backImage
        navigation.backItem?.title = ""
    }
}

