//
//  RecipeCollectionViewCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/21/23.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = appBackgroundColor
        return imageView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.recipeNameLabel.textColor = appTextColor
        self.backgroundView = backgroundImage
        self.backgroundView?.clipsToBounds = true
        self.backgroundView?.layer.cornerRadius = 20
        self.recipeImageView.layer.cornerRadius = 3
    }
    
    func configure(for favoriteRecipe: FavoriteRecipe) {
        recipeNameLabel.text = favoriteRecipe.title
        
        if let urlString = favoriteRecipe.photoString {
            let url = URL(string: urlString)!
            recipeImageView.downloadImage(url: url)
        }
        
        if favoriteRecipe.hasPhoto, let image = favoriteRecipe.photoImage {
            recipeImageView.image = image
        }
    }

}
