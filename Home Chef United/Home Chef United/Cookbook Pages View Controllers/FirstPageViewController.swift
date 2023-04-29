//
//  FirstPageViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/24/23.
//

import UIKit

class FirstPageViewController: UIViewController {
    
    var username: String?

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
                sourceLabel.text = "Written By: \(username!)" // Replace with the user's username
            case "Online Recipes":
                sourceLabel.text = "Origin: \((recipe.origin)!)"
            case "Other User Recipes":
                print("TO DO")
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
        
        /*if recipe.sectionCategory == "My Recipes" {
            getUsername(completion: { data in
                self.sourceLabel.text = "Written By: \(data)" // Replace with the user's username
            })
        }*/
    }
    
    /*func getUsername(completion:@escaping (String)-> Void) {
        let userRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let username = document.data()!["username"] as! String
                completion(username)
            }
            else {
                print("User does not exist")
                completion("")
            }
        }
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
