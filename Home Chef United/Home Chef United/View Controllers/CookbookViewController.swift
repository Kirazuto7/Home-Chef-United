//
//  CookbookViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/21/23.
//

import UIKit
import CoreData

class CookbookViewController: UITableViewController {
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var deleteMode = false // User pressed delete button to remove recipes
    var managedObjectContext: NSManagedObjectContext!
    
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
        let alertActivated = UIAlertController(title: "Delete Mode Activated", message: "Click any recipe that you would like to remove or press the button again to deactive delete mode", preferredStyle: .alert)
        let alertDeactivated = UIAlertController(title: "Delete Mode Deactivated", message: "Delete Mode has been deactived", preferredStyle: .alert)
        deleteMode = !deleteMode
        
        if deleteMode {
            deleteButton.image = UIImage(systemName: "trash")
            deleteButton.tintColor = UIColor.red
            presentAlert(alertActivated, for: self)
        }
        else {
            deleteButton.image = UIImage(systemName: "trash.slash")
            deleteButton.tintColor = UIColor.blue
            presentAlert(alertDeactivated, for: self)
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
            cell.updateCellWith(row: recipeArray, for: indexPath.section)
         }
        
        cell.cellDelegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let categoryLabel = UILabel(frame: CGRect(x: 8, y: 0, width: 200, height: 30))
        headerView.addSubview(categoryLabel)
        categoryLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        let sectionInfo = fetchedFavoriteRecipesController.sections![section]
        categoryLabel.text = sectionInfo.name
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateRecipeSegue" {
            let createRecipeVC = segue.destination as! CreateRecipeViewController
            createRecipeVC.managedObjectContext = managedObjectContext
        }
        else if segue.identifier == "CookbookPagesSegue" {
            if let recipePagesVC = segue.destination as? CookbookPageViewController, let recipe = sender as? FavoriteRecipe {
                recipePagesVC.recipe = recipe
            }
        }
    }

}

extension CookbookViewController: RecipeCollectionViewCellDelegate {
    
    func recipeCollectionView(recipeCollectionView: RecipeCollectionViewCell?, index: Int, section: Int, tableViewCell: CookbookTableViewCell) {
        if !deleteMode {
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
