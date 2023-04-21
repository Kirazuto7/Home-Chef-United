//
//  RecipeCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import UIKit

class RecipeCell : UITableViewCell {
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var favoritedImageView: UIImageView!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var numIngredientsLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    
    var downloadTask: URLSessionDownloadTask?
    
    func configure(for recipe: Recipe, liked isFavorited: Bool) {
        let ingredients = getRecipeIngredients(for: recipe)
        recipeNameLabel.text = recipe.name
        numIngredientsLabel.text = "# Ingredients: \(ingredients.count)"
        originLabel.text = "Origin: \(recipe.origin!)"
        recipeImageView.image = UIImage(systemName: "square")
        if let url = URL(string: recipe.imageURL!) {
            downloadTask = recipeImageView.downloadImage(url: url)
        }
        
        if !isFavorited {
            favoritedImageView.image = UIImage(systemName: "star")
        }
        else {
            favoritedImageView.image = UIImage(systemName: "star.fill")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
}

