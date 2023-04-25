//
//  TabBarViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/15/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustStatusBarColor()
    }
    
    func adjustStatusBarColor() {
        let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? UIApplication.shared.statusBarFrame
        let statusBarView = UIView(frame: statusBarFrame)
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
