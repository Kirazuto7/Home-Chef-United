//
//  RecipeDetailViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/19/23.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseAuth

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
    var userRecipe: [String:Any]?
    var downloadTask: URLSessionDownloadTask?
    var ingredientsCellHeight: CGFloat = 44
    var managedObjectContext: NSManagedObjectContext!
    let defaults = UserDefaults.standard
    let user = Auth.auth().currentUser
    
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
            for ingredient in ingredients {
                let ingredientLabel = UILabel()
                let measurementLabel = UILabel()
                ingredientLabel.text = "\(ingredient.1.0)"
                ingredientLabel.textColor = UIColor.black
                ingredientLabel.frame = CGRect(x: 0, y: y, width: 155, height: 20)
                measurementLabel.text = "\(ingredient.1.1)"
                measurementLabel.textColor = UIColor.black
                measurementLabel.frame = CGRect(x: 180, y: y, width: 200, height: 20)
                ingredientsStackView.addSubview(ingredientLabel)
                ingredientsStackView.addSubview(measurementLabel)
                y += 20
            }
            ingredientsCellHeight += y
            ingredientsCell.layer.isHidden = false
            ingredientsCell.layer.borderWidth = 2
            ingredientsCell.layer.borderColor = UIColor.lightGray.cgColor
            tableView.endUpdates()
        }
        
        if let userRecipe = userRecipe {
            let name = userRecipe["name"] as! String
            let author = userRecipe["author"] as! String
            let ingredients = userRecipe["ingredients"] as! [String]
            let measurements = userRecipe["measurements"] as? [String:Any]
            let instructions = userRecipe["instructions"] as! [String]
            let urlString = userRecipe["imageURLString"] as! String
            recipeNameLabel.text = name
            originLabel.text = "Written By: \(author)"
            
            if let url = URL(string: urlString) {
                downloadTask = recipeImageView.downloadImage(url: url)
                recipeImageView.layer.masksToBounds = true
                recipeImageView.layer.cornerRadius = recipeImageView.frame.height / 10.0
            }
            
            var stepCounter = 1

            var textViewString = "Steps:\n\n"
            for instruction in instructions {
                textViewString += "\(stepCounter)) \(instruction)\n\n"
                stepCounter += 1
            }
            recipeStepsTextView.text = textViewString
            tableView.beginUpdates()
            var y: CGFloat = 0
            for ingredient in ingredients {
                let horizontalStackView = UIStackView()
                let ingredientLabel = UILabel()
                let measurementLabel = UILabel()
                ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
                measurementLabel.translatesAutoresizingMaskIntoConstraints = false
                horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
                ingredientLabel.text = "\(ingredient)"
                ingredientLabel.textColor = UIColor.black
                if let measurementDict = measurements {
                    if let measurement = measurementDict[ingredient]  {
                        measurementLabel.text = "\(measurement)"
                        measurementLabel.textColor = UIColor.black
                    }
                }
                
                horizontalStackView.alignment = .fill
                horizontalStackView.axis = .horizontal
                horizontalStackView.distribution = .equalCentering
                horizontalStackView.addArrangedSubview(ingredientLabel)
                horizontalStackView.addArrangedSubview(measurementLabel)
                ingredientsStackView.addArrangedSubview(horizontalStackView)
                y += 20
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
        // MARK: - Save the recipe to User Core Data to retrieve in cookbook
        
        if let recipe = recipe {
            let favoriteRecipe = FavoriteRecipe(context: managedObjectContext)
            let ingredientsMap = getRecipeIngredients(for: recipe) // map where key = #, value = (ingredient, measurement)
            let instructions = getRecipeInstructionSteps(for: recipe)
            
            var ingredients = [String]()
            var measurements = [String:String]()
            
            for (_, value) in ingredientsMap {
                ingredients.append(value.0)
                measurements[value.0] = value.1
            }
            
            favoriteRecipe.date = Date()
            favoriteRecipe.title = recipe.name!
            favoriteRecipe.instructions = instructions
            favoriteRecipe.ingredients = ingredients
            favoriteRecipe.measurements = measurements
            favoriteRecipe.youtubeURL = recipe.youtubeURL
            favoriteRecipe.origin = recipe.origin
            favoriteRecipe.prepTime = 0
            favoriteRecipe.sectionCategory = "Online Recipes"
            favoriteRecipe.photoString = recipe.imageURL
            favoriteRecipe.userID = user?.uid
            
            do {
                try managedObjectContext.save()
                defaults.set(favoriteRecipe.title, forKey: MOST_RECENT_RECIPE_TITLE_KEY)
                defaults.set(favoriteRecipe.photoString, forKey: MOST_RECENT_RECIPE_IMAGE_KEY)
                defaults.set(favoriteRecipe.date, forKey: MOST_RECENT_RECIPE_DATE_KEY)
                let alert = UIAlertController(title: "Successfully Saved!", message: "", preferredStyle: .alert)
                presentAlert(alert, for: self)
                afterDelay(0.6) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            catch {
                fatalCoreDataError(error)
            }
        }
        else if let userRecipe = userRecipe {
            let favoriteRecipe = FavoriteRecipe(context: managedObjectContext)
            let name = userRecipe["name"] as! String
            let author = userRecipe["author"] as! String
            let ingredients = userRecipe["ingredients"] as! [String]
            let instructions = userRecipe["instructions"] as! [String]
            let urlString = userRecipe["imageURLString"] as! String
            
            favoriteRecipe.date = Date()
            favoriteRecipe.title = name
            favoriteRecipe.instructions = instructions
            favoriteRecipe.ingredients = ingredients
            favoriteRecipe.prepTime = userRecipe["prepTime"] as? Double ?? 0
            favoriteRecipe.youtubeURL = userRecipe["youtubeURL"] as? String ?? ""
            favoriteRecipe.sectionCategory = "Other User Recipes"
            favoriteRecipe.photoString = urlString
            favoriteRecipe.author = author
            favoriteRecipe.userID = user?.uid
            
            if let measurements = userRecipe["measurements"] as? [String:String] {
                favoriteRecipe.measurements = measurements
            }
            
            do {
                try managedObjectContext.save()
                defaults.set(favoriteRecipe.title, forKey: MOST_RECENT_RECIPE_TITLE_KEY)
                defaults.set(favoriteRecipe.photoString, forKey: MOST_RECENT_RECIPE_IMAGE_KEY)
                defaults.set(favoriteRecipe.date, forKey: MOST_RECENT_RECIPE_DATE_KEY)
                let alert = UIAlertController(title: "Successfully Saved!", message: "", preferredStyle: .alert)
                presentAlert(alert, for: self)
                afterDelay(0.6) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            catch {
                fatalCoreDataError(error)
            }
        
        }
        else {
            let alert = UIAlertController(title: "Save Unsuccessful", message: "Please try to save the recipe again later...", preferredStyle: .alert)
            presentAlert(alert, for: self)
        }
    }
    
    @IBAction func watchVideo(_ sender: Any) {
        let alert = UIAlertController(title: "Watch Video", message: "You will be redirected to Youtube to watch how to cook this recipe", preferredStyle: .alert)
        let action = UIAlertAction(title: "Play", style: .default) { _ in
            self.redirectToYoutube()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func redirectToYoutube() {
        if recipe != nil {
            if let url = recipe!.youtubeURL {
                let videoID = convertToYoutubeID(for: recipe!)
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
        else if userRecipe != nil {
            if let url = userRecipe!["youtubeURL"] as? String {
                var youtubeUrl = URL(string: url)!
                
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
