//
//  CreateRecipeViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/22/23.
//

import UIKit
import CoreData


class CreateRecipeViewController: UITableViewController {
    
    var ingredientsIndexPaths = [IndexPath]()
    var ingredientsMap = [Int:(String, String)]() // Key = Ingredient #, Value = Ingredient, Measurement
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        initializeCellNibs()
        ingredientsIndexPaths.append(IndexPath(row: 0, section: 1))
    }
    
    func initializeCellNibs() {
        var cellNib = UINib(nibName: "AddIngredientsViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AddIngredientsViewCell")
        cellNib = UINib(nibName: "AddRecipeFirstSectionViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AddRecipeCell")
        cellNib = UINib(nibName: "RecipeInstructionsViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "RecipeInstructionsViewCell")
        cellNib = UINib(nibName: "AddExtraRecipeInfoViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "AddExtraRecipeInfoViewCell")
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveRecipe(_ sender: Any) {
        var saveImage: UIImage?
        var saveTitle: String = ""
        var savePrepTime: Double = 0
        var saveYoutubeURLString: String = ""
        var saveInstructions: [String] = [String]()
        var saveMeasurements: [String:String] = [String:String]()
        var saveIngredients: [String] = [String]()
        
        // Gets Recipe Name and Image Data
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddRecipeFirstSectionViewCell {
            // Guard against empty recipe titles
            guard !cell.recipeTitleTextField.text!.isEmpty else {
                let alert = UIAlertController(title: "Save Failed", message: "Recipe title cannot be empty", preferredStyle: .alert)
                presentAlert(alert, for: self)
                return
            }
            guard cell.recipeImageView.image != nil else {
                let alert = UIAlertController(title: "Save Failed", message: "Please set a recipe image", preferredStyle: .alert)
                presentAlert(alert, for: self)
                return
            }
            saveTitle = cell.recipeTitleTextField.text!
            saveImage = cell.recipeImageView.image!
        }
        
        // Gets Ingredients & Measurements Data
        var index = 1
        for ingredientPath in ingredientsIndexPaths {
            let cell = tableView.cellForRow(at: ingredientPath) as! AddIngredientsViewCell
            var ingredientMeasurement: (String, String) = ("","")
            if let ingredient = cell.ingredientTextField.text, !ingredient.isEmpty {
                ingredientMeasurement.0 = ingredient
            }
            if let measurement = cell.measurementTextField.text, !measurement.isEmpty {
                ingredientMeasurement.1 = measurement
            }
            // Guard against measurement fields that have no ingredient
            guard (ingredientMeasurement.1.isEmpty && !ingredientMeasurement.0.isEmpty) ||
                  (!ingredientMeasurement.0.isEmpty && !ingredientMeasurement.1.isEmpty) ||
                  (ingredientMeasurement.0.isEmpty && ingredientMeasurement.1.isEmpty) else {
                let alert = UIAlertController(title: "Save Failed", message: "Every measurement must have an ingredient associated with it", preferredStyle: .alert)
                presentAlert(alert, for: self)
                return
            }
            // Ignore ingredient and measurement pairings that are both empty
            if(!(ingredientMeasurement.0.isEmpty && ingredientMeasurement.1.isEmpty)) {
                ingredientsMap[index] = ingredientMeasurement
                index += 1
            }
        }
        
        for (_, value) in ingredientsMap {
            saveIngredients.append(value.0)
            if !value.1.isEmpty {
                saveMeasurements[value.0] = value.1
            }
        }
        // Users must have at least one ingredient in their recipe
        guard !ingredientsMap.isEmpty else {
            let alert = UIAlertController(title: "Save Failed", message: "You must add at least one ingredient", preferredStyle: .alert)
            presentAlert(alert, for: self)
            return
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? RecipeInstructionsViewCell {
            guard !cell.instructionsTextView.text.isEmpty else {
                let alert = UIAlertController(title: "Save Failed", message: "Please write instructions on how to make your recipe", preferredStyle: .alert)
                presentAlert(alert, for: self)
                return
            }
            
            let instructionsSummary = cell.instructionsTextView.text!
            saveInstructions = instructionsSummary.convertToSentences()
        }
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as? AddExtraRecipeInfoViewCell {
            if let time = cell.prepTimeTextField.text {
                savePrepTime = Double(time) ?? 0
            }
            saveYoutubeURLString = cell.youtubeURLTextField.text ?? ""
        }
        
        // MARK: - Save to Core Data
        guard !saveTitle.isEmpty else { return }
        guard !saveInstructions.isEmpty else { return }
        guard !saveIngredients.isEmpty else { return }
        let myFavoriteRecipe = FavoriteRecipe(context: managedObjectContext)
        myFavoriteRecipe.date = Date()
        myFavoriteRecipe.title = saveTitle
        if !saveYoutubeURLString.isEmpty
        {
            myFavoriteRecipe.youtubeURL = saveYoutubeURLString
        }
        myFavoriteRecipe.prepTime = savePrepTime
        myFavoriteRecipe.sectionCategory = "My Recipes"
        myFavoriteRecipe.instructions = saveInstructions
        myFavoriteRecipe.ingredients = saveIngredients
        if !saveMeasurements.isEmpty {
            myFavoriteRecipe.measurements = saveMeasurements
        }
        myFavoriteRecipe.photoID = nil // Value is 0 when initialized, but should be nil
        if let image = saveImage {
            if !myFavoriteRecipe.hasPhoto {
                myFavoriteRecipe.photoID = FavoriteRecipe.nextPhotoID() as NSNumber
            }
            if let data = image.jpegData(compressionQuality: 0.5) {
                do {
                    try data.write(to: myFavoriteRecipe.photoURL, options: .atomic)
                }
                catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        catch {
            fatalCoreDataError(error)
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return ingredientsIndexPaths.count
        }
        
        if section == 2 {
            return 1
        }
        
        if section == 3 {
            return 1
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let recipeCell = tableView.dequeueReusableCell(withIdentifier: "AddRecipeCell", for: indexPath) as! AddRecipeFirstSectionViewCell
            recipeCell.delegate = self
            recipeCell.recipeTitleTextField.delegate = self
            return recipeCell
        }
        if indexPath.section == 1 {
            let ingredientsCell = tableView.dequeueReusableCell(withIdentifier: "AddIngredientsViewCell", for: indexPath) as! AddIngredientsViewCell
            ingredientsCell.delegate = self
            if indexPath.row == 0 {
                ingredientsCell.removeButton.isHidden = true
            }
            if indexPath.row == ingredientsIndexPaths.count-1 {
                ingredientsCell.addButton.isHidden = false
            }
            return ingredientsCell
        }
        if indexPath.section == 2 {
            let recipeInstructionsCell = tableView.dequeueReusableCell(withIdentifier: "RecipeInstructionsViewCell", for: indexPath) as! RecipeInstructionsViewCell
            recipeInstructionsCell.instructionsTextView.delegate = self
            recipeInstructionsCell.layer.borderWidth = 2
            recipeInstructionsCell.layer.borderColor = UIColor.orange.cgColor
            return recipeInstructionsCell
        }
        if indexPath.section == 3 {
            let extraInfoCell = tableView.dequeueReusableCell(withIdentifier: "AddExtraRecipeInfoViewCell", for: indexPath) as! AddExtraRecipeInfoViewCell
            return extraInfoCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 314
        }
        
        if indexPath.section == 2 {
            return 400
        }
        
        if indexPath.section == 3 {
            return 90
        }
        
        return 44
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Recipe Details (Required)"
        }
        
        if section == 1 {
          return "Ingredients (Required)"
        }
        
        if section == 2 {
            return "Recipe Instructions (Required)"
        }
        
        if section == 3 {
            return "Additional Info (Optional)"
        }
        
        return ""
    }
    
}

extension CreateRecipeViewController: AddIngredientsViewCellDelegate {
    
    func didAddTap(_ addIngredientsViewCell: AddIngredientsViewCell) {
        let newRowIndex = ingredientsIndexPaths.count
        addIngredientsViewCell.addButton.isHidden = true
        ingredientsIndexPaths.append(IndexPath(row: newRowIndex, section: 1))
        tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 1)], with: .automatic)
    }
    
    func didRemoveTap(_ addIngredientsViewCell: AddIngredientsViewCell) {
        let indexPath = self.tableView.indexPath(for: addIngredientsViewCell)!
        
        // Configure button visibility
        if indexPath.row == ingredientsIndexPaths.count - 1 {
            let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: 1)) as! AddIngredientsViewCell
            cell.addButton.isHidden = false
        }
        
        ingredientsIndexPaths.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension CreateRecipeViewController: AddRecipeFirstSectionViewCellDelegate {
    
    func setRecipePhoto(_ addRecipeFirstSectionViewCell: AddRecipeFirstSectionViewCell) {
        pickPhoto()
    }
}

// MARK: - Delegates for choosing a Recipe Image
extension CreateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func showPhotoMenu() {
        // Slides in from the bottom providing choices
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default){ _ in
            self.takePhotoWithCamera()
        }
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        }
        else {
            choosePhotoFromLibrary()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        if let recipeImage = image {
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddRecipeFirstSectionViewCell
            cell.recipeImageView.image = recipeImage
            cell.placeholderImageView.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateRecipeViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let toolbar = UIToolbar()
        let clearButton = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(resetTextView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTextViewKeyboard))
        toolbar.setItems([clearButton, spaceButton, doneButton], animated: true)
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        return true
    }
    
    @objc func dismissTextViewKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    @objc func resetTextView() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! RecipeInstructionsViewCell
        cell.instructionsTextView.text = ""
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
