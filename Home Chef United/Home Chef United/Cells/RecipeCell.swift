//
//  RecipeCell.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import UIKit

class RecipeCell : UITableViewCell {
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var numIngredientsLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var downloadTask: URLSessionDownloadTask?
    
    func configure(for recipe: Recipe) {
        let ingredients = getRecipeIngredients(for: recipe)
        recipeNameLabel.text = recipe.name
        numIngredientsLabel.text = "# Ingredients: \(ingredients.count)"
        originLabel.text = "Ethnic Origin: \(recipe.origin!)"
        recipeImageView.image = UIImage(systemName: "square")
        if let url = URL(string: recipe.imageURL!) {
            downloadTask = recipeImageView.downloadImage(url: url)
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

