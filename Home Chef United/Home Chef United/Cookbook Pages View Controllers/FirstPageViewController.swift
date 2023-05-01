//
//  FirstPageViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/24/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class FirstPageViewController: UIViewController {
    
    @IBOutlet weak var recipeTitleLabel: UILabel! {
        didSet {
            recipeTitleLabel.text = recipe.title
        }
    }
    @IBOutlet weak var recipeImageView: UIImageView! {
        didSet {
            if let urlString = recipe.photoString {
                let url = URL(string: urlString)!
                recipeImageView.downloadImage(url: url)
            }
            
            if ((recipe?.hasPhoto) != nil), let image = recipe?.photoImage {
                recipeImageView.image = image
            }
            
            recipeImageView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var sourceLabel: UILabel! {
    
        didSet {
            switch recipe?.sectionCategory{
            case "My Recipes":
                sourceLabel.text = "Written By: \(Auth.auth().currentUser!.displayName!)" // Replace with the user's username
            case "Online Recipes":
                sourceLabel.text = "Origin: \((recipe.origin)!)"
            case "Other User Recipes":
                sourceLabel.text = "Written By: \(recipe.author!)"
            default:
                print("UNKNOWN")
            }
        }
    }
    
    @IBOutlet weak var additionalInfoLabel: UILabel! {
        didSet {
            if let time = recipe?.prepTime, time != 0 {
                additionalInfoLabel.text = "Cook Time: \(time)"
            }
            else {
                additionalInfoLabel.isHidden = true
            }
        }
    }
    
    var recipe: FavoriteRecipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBackgroundView(for: self.view, with: UIImage(named: "RecipeCover")!)
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
