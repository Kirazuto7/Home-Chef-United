//
//  SecondViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/24/23.
//

import UIKit

class SecondPageViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var ingredientsTableView: UITableView!
   
    var recipe: FavoriteRecipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        setupBackgroundView(for: self.view, with: UIImage(named: "RecipePage")!)
        let image = UIImage(systemName: "xmark.app.fill")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .bold))?.withRenderingMode(.alwaysTemplate)
            closeButton.setImage(image, for: .normal)
    }
    
    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SecondPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "CookbookIngredientsCell", for: indexPath) as! CookbookIngredientsCell
        let ingredient = recipe.ingredients[indexPath.row]
        ingredientCell.ingredientNumberLabel.text = "\(indexPath.row + 1))"
        ingredientCell.ingredientNameLabel.text = ingredient
        
        if recipe.measurements != nil {
            if let measurement = recipe.measurements![ingredient] {
                ingredientCell.ingredientMeasurementLabel.text = measurement
            }
        }
        return ingredientCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredient Name & Measurement"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
