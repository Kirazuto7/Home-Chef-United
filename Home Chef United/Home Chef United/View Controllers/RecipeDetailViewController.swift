//
//  RecipeDetailViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/19/23.
//

import UIKit

class RecipeDetailViewController: UITableViewController {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    @IBOutlet weak var ingredientsCell: UITableViewCell!
    @IBOutlet weak var recipeStepsTextView: UITextView!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var youtubeButton: UIButton!
    @IBOutlet weak var saveRecipeButton: UIButton!
    
    var recipe: Recipe?
    var downloadTask: URLSessionDownloadTask?
    var ingredientsCellHeight: CGFloat = 44

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initializeDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    // MARK: - Helper Functions
    
    func setupViews() {
        recipeStepsTextView.sizeToFit()
        recipeStepsTextView.isScrollEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func initializeDetails() {
        if let recipe = recipe {
            let ingredients = getRecipeIngredients(for: recipe)
            let instructions = getRecipeInstructionSteps(for: recipe)
            var stepCounter = 1
            var textViewString = "Steps:\n\n"
            for instruction in instructions {
                textViewString += "\(stepCounter)) \(instruction)\n\n" 
                stepCounter += 1
            }
            recipeStepsTextView.text = textViewString
            recipeNameLabel.text = recipe.name!
            originLabel.text = "Ethnic Origin: \(recipe.origin ?? "N/A")"
            if let url = URL(string: recipe.imageURL!) {
                downloadTask = recipeImageView.downloadImage(url: url)
                recipeImageView.layer.masksToBounds = true
                recipeImageView.layer.cornerRadius = recipeImageView.frame.height / 10.0
            }
            
            // Add the ingredients list to the stack view and update the height of the ingredients cell
            tableView.beginUpdates()
            var y: CGFloat = 0
            var index = 1
            for ingredient in ingredients {
                let ingredientLabel = UILabel()
                let measurementLabel = UILabel()
                ingredientLabel.text = "\(index).  \(ingredient.1.0)"
                ingredientLabel.textColor = UIColor.black
                ingredientLabel.frame = CGRect(x: 0, y: y, width: 155, height: 20)
                measurementLabel.text = "\(ingredient.1.1)"
                measurementLabel.textColor = UIColor.black
                measurementLabel.frame = CGRect(x: 180, y: y, width: 200, height: 20)
                ingredientsStackView.addSubview(ingredientLabel)
                ingredientsStackView.addSubview(measurementLabel)
                y += 20
                index += 1
            }
            ingredientsCellHeight += y
            ingredientsCell.layer.isHidden = false
            ingredientsCell.layer.borderWidth = 2
            ingredientsCell.layer.borderColor = UIColor.lightGray.cgColor
            tableView.endUpdates()
        }
    }
    
    // MARK: - Outlet Functions
    
    @IBAction func saveToCookbook(_ sender: Any) {
        // TODO: - Save the recipe to User Core Data to retrieve in cookbook
    }
    
    @IBAction func watchVideo(_ sender: Any) {
        let alert = UIAlertController(title: "Watch Video", message: "You will be redirected to Youtube to watch how to cook this recipe", preferredStyle: .alert)
        let action = UIAlertAction(title: "Play", style: .default) { _ in
            self.redirectToYoutube(recipe: self.recipe!)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func redirectToYoutube(recipe: Recipe) {
        if let url = recipe.youtubeURL {
            let videoID = convertToYoutubeID(for: recipe)
            var youtubeUrl = URL(string: "youtube://\(videoID)")!
            
            // Opens in Youtube App
            if UIApplication.shared.canOpenURL(youtubeUrl) {
                UIApplication.shared.open(youtubeUrl)
            }
            else { // Opens in Browser
                youtubeUrl = URL(string: url)!
                UIApplication.shared.open(youtubeUrl)
            }
        }
        else {
            let alert = UIAlertController(title: "", message: "Sorry this recipe does not have any video", preferredStyle: .alert)
            present(alert, animated: true)
            
            let delay = DispatchTime.now() + 3
            
            DispatchQueue.main.asyncAfter(deadline: delay) {
                alert.dismiss(animated: true)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Recipe Image
        if indexPath.section == 0 && indexPath.row == 1 {
            return 250
        }
        
        // Ingredients List
        if indexPath.section == 1 && indexPath.row == 1 {
            return ingredientsCellHeight
        }
        
        // Everything else
        return UITableView.automaticDimension
    }
}
