//
//  TabBarViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/15/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let statusBarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustStatusBarColor()
        tabBar.isTranslucent = false
        
        let cookbookNavController = self.viewControllers![1] as! UINavigationController
        let cookbookVC = cookbookNavController.viewControllers.first as! CookbookViewController
        cookbookVC.statusBarView = statusBarView
    }
    
    func adjustStatusBarColor() {
        let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? UIApplication.shared.statusBarFrame
        statusBarView.frame = statusBarFrame
        statusBarView.backgroundColor = appBackgroundColor
        view.addSubview(statusBarView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
