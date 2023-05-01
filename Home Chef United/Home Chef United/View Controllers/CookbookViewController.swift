//
//  CookbookViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/21/23.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class CookbookViewController: UITableViewController {
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var deleteMode = false // User pressed delete button to remove recipes
    var editMode = false // User pressed edit button to edit recipes
    var managedObjectContext: NSManagedObjectContext!
    var db: Firestore!
    var statusBarView: UIView?
    
    lazy var editButton: UIButton =  {
        let editButton = UIButton()
        editButton.translatesAutoresizingMaskIntoConstraints =  false
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = UIColor.link
        return editButton
    }()
    
    lazy var fetchedFavoriteRecipesController: NSFetchedResultsController<FavoriteRecipe> = {
        let fetchRequest = NSFetchRequest<FavoriteRecipe>()
        let entity = FavoriteRecipe.entity()
        fetchRequest.entity = entity
        
        let sortByCategory = NSSortDescriptor(key: "sectionCategory", ascending: true)
        let sortByDate = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortByCategory, sortByDate]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "sectionCategory", cacheName: "FavoriteRecipes")
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CookbookTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "CookbookTableViewCell")
        
        fetchFavoriteRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "My Cookbook"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    deinit {
        fetchedFavoriteRecipesController.delegate = nil
    }
    
    func fetchFavoriteRecipes() {
        do {
            try fetchedFavoriteRecipesController.performFetch()
        }
        catch {
            fatalCoreDataError(error)
        }
    }
    
    
    // MARK: - Outlet Actions

    @IBAction func removeRecipes(_ sender: Any) {
        let alertActivated = UIAlertController(title: "Delete Mode", message: "Click on any recipe to delete them or press the button again to deactive delete mode", preferredStyle: .alert)
        let alertDeactivated = UIAlertController(title: "Delete Mode Deactivated", message: "Delete Mode has been deactived", preferredStyle: .alert)
        deleteMode = !deleteMode
        
        if editMode {
            editMode = false
            editButton.tintColor = UIColor.link
        }
        
        if deleteMode {
            deleteButton.image = UIImage(systemName: "trash")
            deleteButton.tintColor = UIColor.red
            presentAlert(alertActivated, for: self)
        }
        else {
            deleteButton.image = UIImage(systemName: "trash.slash")
            deleteButton.tintColor = UIColor.link
            presentAlert(alertDeactivated, for: self)
        }
    }
    
    
    @objc func editRecipes(_ editButton: UIButton) {
        editMode = !editMode
        
        if deleteMode {
            deleteMode = false
            deleteButton.image = UIImage(systemName: "trash.slash")
            deleteButton.tintColor = UIColor.link
        }
        
        if editMode {
            let alertActivated = UIAlertController(title: "Edit Mode", message: "Click on your recipe to edit them", preferredStyle: .alert)
            presentAlert(alertActivated, for: self)
            editButton.tintColor = .red
        }
        else {
            editButton.tintColor = UIColor.link
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedFavoriteRecipesController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // My Recipes, Online Recipes, Other User Recipes
        let sectionInfo = fetchedFavoriteRecipesController.sections![section]
        return sectionInfo.name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CookbookTableViewCell") as! CookbookTableViewCell
        
        if let recipeArray = fetchedFavoriteRecipesController.sections![indexPath.section].objects as? [FavoriteRecipe] {
            cell.updateCellWith(row: recipeArray, for: indexPath.section, as: fetchedFavoriteRecipesController.sections![indexPath.section].name)
         }
        
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(categoryLabel)
        categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        categoryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        
        let sectionInfo = fetchedFavoriteRecipesController.sections![section]
        categoryLabel.text = sectionInfo.name
        
        if sectionInfo.name == "My Recipes" {
            headerView.addSubview(editButton)
            editButton.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 16).isActive = true
            editButton.addTarget(self, action: #selector(editRecipes(_:)), for: .touchUpInside)
        }
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateRecipeSegue" {
            editMode = false
            deleteMode = false
            deleteButton.image = UIImage(systemName: "trash.slash")
            deleteButton.tintColor = UIColor.link
            editButton.tintColor = UIColor.link
            
            let createRecipeVC = segue.destination as! CreateRecipeViewController
            createRecipeVC.managedObjectContext = self.managedObjectContext
            createRecipeVC.db = self.db
        }
        else if segue.identifier == "CookbookPagesSegue" && !editMode {
            if let recipePagesVC = segue.destination as? CookbookPageViewController, let recipe = sender as? FavoriteRecipe {
                recipePagesVC.recipe = recipe
                recipePagesVC.statusBarView = statusBarView
            }
        }
        else if segue.identifier == "EditRecipeSegue" && editMode {
            if let editRecipeVC = segue.destination as? CreateRecipeViewController, let recipe = sender as? FavoriteRecipe {
                editRecipeVC.managedObjectContext = managedObjectContext
                editRecipeVC.recipeToEdit = recipe
            }
        }
    }
    

}

extension CookbookViewController: RecipeCollectionViewCellDelegate {
    
    func recipeCollectionView(recipeCollectionView: RecipeCollectionViewCell?, index: Int, section: Int, tableViewCell: CookbookTableViewCell) {
        if !deleteMode && !editMode {
            if let row = tableViewCell.recipeCells {
                let recipe = row[index]
                performSegue(withIdentifier: "CookbookPagesSegue", sender: recipe)
            }
        }
    }
    
    func removeRecipeFromCollectionView(recipeCollectionView: RecipeCollectionViewCell?, index: Int, section: Int, tableViewCell: CookbookTableViewCell) {
        if deleteMode {
            if let row = tableViewCell.recipeCells {
                let recipe = row[index]
                
                let alert = UIAlertController(title: "DELETE \(recipe.title)", message: "Are you sure?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.deleteRecipe(recipe)
                }
                alert.addAction(cancel)
                alert.addAction(delete)
                present(alert, animated: true)
            }
        }
    }
    
    func editRecipeFromCollectionView(recipeCollectionView: RecipeCollectionViewCell?, index: Int, section: Int, sectionName: String, tableViewCell: CookbookTableViewCell) {
        if editMode && sectionName == "My Recipes" {
            if let row = tableViewCell.recipeCells {
                let recipe = row[index]
                performSegue(withIdentifier: "EditRecipeSegue", sender: recipe)
            }
        }
    }
    
    func deleteRecipe(_ recipe: FavoriteRecipe) {
        recipe.removePhotoFile()
        managedObjectContext.delete(recipe)
        do {
            try managedObjectContext.save()
        }
        catch {
            fatalCoreDataError(error)
        }
    }
}

extension CookbookViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Content Will Update!")
        //tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            print("INSERT OBJECT")
            if let cell = tableView.cellForRow(at: newIndexPath!) as? CookbookTableViewCell {
                cell.recipesCollectionView.insertItems(at: [newIndexPath!])
            }
        case .delete:
            print("Deleted object!")
            if let cell = tableView.cellForRow(at: indexPath!) as? CookbookTableViewCell {
                cell.recipesCollectionView.deleteItems(at: [indexPath!])
            }
        case .update:
            print("UPDATE OBJECT")
            
        case .move:
            print("MOVE OBJECT")
            
        @unknown default:
            print("UNKNOWN")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            print("Insert Section")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("Delete Section")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            print("Update Section")
        case.move:
            print("Move Section")
        @unknown default:
            print("UNKNOWN")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Content Change Complete")
        tableView.reloadData()
    }
}
