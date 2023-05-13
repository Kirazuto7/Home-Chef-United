//
//  RecipeCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import UIKit
import FirebaseCore
import FirebaseStorage

class UserRecipeCell : UITableViewCell {
    
    @IBOutlet weak var authorPhotoImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var numIngredientsLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    var downloadTask: URLSessionDownloadTask?
    
    func configure(for recipe: [String:Any]) {
        let name = recipe["name"] as! String
        let author = recipe["author"] as! String
        let authorID = recipe["authorID"] as! String
        let ingredients = recipe["ingredients"] as! [String]
        let urlString = recipe["imageURLString"] as! String
        
        recipeNameLabel.text = name
        authorLabel.text = "Written By: \(author)"
        numIngredientsLabel.text = "# Ingredients: \(ingredients.count)"
        if let cookTime = recipe["prepTime"] as? Int {
            timeLabel.text = "Cook Time: \(cookTime) mins"
        }
        else {
            timeLabel.isHidden = true
        }
        
        if let url = URL(string: urlString) {
            downloadTask = recipeImageView.downloadImage(url: url)
        }
        recipeImageView.layer.cornerRadius = 10
        
        let storageRef = Storage.storage().reference()
        let profilePhotoRef = storageRef.child("\(authorID)/profilePhoto.jpg")
        
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
        
        cellView.clipsToBounds = true
        setAppBackground(forView: cellView)
        cellView.layer.cornerRadius = 10
        cellView.layer.borderWidth = 2
        cellView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
}
