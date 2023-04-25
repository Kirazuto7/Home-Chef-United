//
//  ThirdPageViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/24/23.
//

import UIKit

class ThirdPageViewController: UIViewController {
    
    var recipe: FavoriteRecipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView(for: self.view, with: UIImage(named: "RecipePage")!)
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
