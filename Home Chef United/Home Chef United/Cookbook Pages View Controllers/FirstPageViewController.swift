//
//  FirstPageViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/24/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class FirstPageViewController: UIViewController {
    
    
    @IBOutlet weak var authorPhotoImageView: UIImageView! {
        didSet {
            switch recipe?.sectionCategory{
            case "My Recipes":
                let storageRef = Storage.storage().reference()
                let profilePhotoRef = storageRef.child("\(Auth.auth().currentUser!.uid)/profilePhoto.jpg")
                
                profilePhotoRef.downloadURL { url, error in
                    if let error = error {
                        print("Error: \(error)")
                    }
                    else {
                        self.authorPhotoImageView.layer.cornerRadius =  self.authorPhotoImageView.layer.bounds.size.width / 2
                        self.authorPhotoImageView.layer.borderWidth = 1
                        self.authorPhotoImageView.downloadImage(url: url!)
                    }
                }
            case "Online Recipes":
                authorPhotoImageView.isHidden = true
            case "Other User Recipes":
                let storageRef = Storage.storage().reference()
                let profilePhotoRef = storageRef.child("\(recipe.authorID!)/profilePhoto.jpg")
                
                profilePhotoRef.downloadURL { url, error in
                    if let error = error {
                        print("Error: \(error)")
                    }
                    else {
                        self.authorPhotoImageView.layer.cornerRadius =  self.authorPhotoImageView.layer.bounds.size.width / 2
                        self.authorPhotoImageView.layer.borderWidth = 1
                        self.authorPhotoImageView.downloadImage(url: url!)
                    }
                }
            default:
                print("UNKNOWN")
            }
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
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
        
        let image = UIImage(systemName: "xmark.app.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))?.withRenderingMode(.alwaysTemplate)
            closeButton.setImage(image, for: .normal)
    }
    
    
    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
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
