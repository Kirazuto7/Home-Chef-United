//
//  HomeViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/15/23.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class RecipeViewController: UITableViewController {
   
    @IBOutlet weak var searchFilterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    var recipesArray = [Recipe]()
    var userRecipesArray = [[String:Any]]()
    var hasSearched = false
    var isLoading = false
    var spinner: UIActivityIndicatorView?
    var recipesDataTask: URLSessionDataTask?
    var selectedIndexPath: IndexPath?
    var managedObjectContext: NSManagedObjectContext!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register views for table view cells
        var cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        setupKeyboard()
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetailSegue" {
            let recipeDetailViewController = segue.destination as! RecipeDetailViewController
            if recipesArray.count > 0 {
                let recipe = recipesArray[selectedIndexPath?.row ?? 0]
                recipeDetailViewController.recipe = recipe
            }
            else if userRecipesArray.count > 0 {
                let userRecipe = userRecipesArray[selectedIndexPath?.row ?? 0]
                recipeDetailViewController.userRecipe = userRecipe
            }
            recipeDetailViewController.managedObjectContext = managedObjectContext
            navigationItem.backButtonTitle = ""
        }
    }
    
    func setupKeyboard() {
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelSearch))
        toolbar.setItems([doneButton], animated: true)
        toolbar.sizeToFit()
        searchBar.inputAccessoryView = toolbar
    }
    
    @objc func cancelSearch() {
        searchBar.text = ""
        dismissKeyboard()
    }
    
    func getUserRecipes(completion:@escaping ([[String:Any]])-> Void) {
        db.collection("recipes").whereField("author", isNotEqualTo: Auth.auth().currentUser?.displayName!).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting recipes from firestore: \(error)")
                //completion([])
            }
            else {
                var tempArray = [[String:Any]]()
                for document in querySnapshot!.documents {
                    tempArray.append(document.data())
                }
                completion(tempArray)
            }
        }
    }
    
    // MARK: - Outlet Action
    
    
    @IBAction func indexSelected(_ sender: Any) {
        tableView.reloadData()
        if searchFilterSegmentedControl.selectedSegmentIndex == 2 {
            let rightButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonSelected(_:)))
            navigationItem.setRightBarButton(rightButton, animated: true)
            searchBar.isHidden = true
            dismissKeyboard()
            let searchRecipesURL = randomRecipeURL()
            searchRecipes(forEndpoint: searchRecipesURL)
        }
        else {
            searchBar.text = ""
            hasSearched = false
            isLoading = false
            recipesArray.removeAll()
            tableView.reloadData()
            navigationItem.setRightBarButton(nil, animated: true)
            searchBar.isHidden = false
        }
    }
    
    @objc func refreshButtonSelected(_ sender: UIBarButtonItem) {
        let searchRecipesURL = randomRecipeURL()
        searchRecipes(forEndpoint: searchRecipesURL)
    }
    
    
    // MARK: - HTTP Method(s)
    // Helper function to parse JSON data into a useable format
    func parseRecipe(data: Data) -> [Recipe] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Recipes.self, from: data)
            return result.recipes
        }
        catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    func searchRecipes(forEndpoint url: URL) {
        recipesDataTask?.cancel()
        hasSearched = true
        isLoading = true
        self.tableView.reloadData() // Show the loading cell
        
        let session = URLSession.shared
        recipesDataTask = session.dataTask(with: url) {
            [weak self] data, response, error in
            
            guard taskErrorCheck(response: response, error: error) == true else {
                DispatchQueue.main.async {
                    self?.spinner?.stopAnimating()
                    self?.isLoading = false
                    self?.tableView.reloadData() // Show nothing found
                }
                return
            }
            // Retrieve recipes data
            if let data = data {
                self?.recipesArray = (self?.parseRecipe(data: data))!
                
                if (self?.recipesArray.count)! > 0 {
                    // Reload the table view after parsing all data
                    DispatchQueue.main.async {
                        self?.spinner?.stopAnimating()
                        self?.hasSearched = false
                        self?.isLoading = false
                        self?.tableView.reloadData()
                    }
                    return
                }
                else { // Passed Task Check Error, but passes empty array
                    DispatchQueue.main.async {
                        self?.spinner?.stopAnimating()
                        self?.isLoading = false
                        self?.tableView.reloadData()
                    }
                    return
                }
                
            } // inside outer data task data closure
        } // end of recipesDataTask
        recipesDataTask?.resume()
    }
    
}
// MARK: - TableView DataSource Methods
extension RecipeViewController {
    
    struct TableView {
        struct CellIdentifiers {
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
            static let recipeCell = "RecipeCell"
            static let userRecipeCell = "UserRecipeCell"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 1
        }
        else if recipesArray.count == 0 && userRecipesArray.count == 0 && hasSearched{
            return 1
        }
        else if recipesArray.count > 0 {
            return recipesArray.count
        }
        else if userRecipesArray.count > 0 {
            return userRecipesArray.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            spinner = cell.viewWithTag(100) as? UIActivityIndicatorView
            spinner?.startAnimating()
            return cell
        }
        else {
            if recipesArray.count == 0 && userRecipesArray.count == 0 && hasSearched {
                return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            }
            else if recipesArray.count > 0 && (searchFilterSegmentedControl.selectedSegmentIndex == 0 || searchFilterSegmentedControl.selectedSegmentIndex == 2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.recipeCell, for: indexPath) as! RecipeCell
                let recipe = recipesArray[indexPath.row]
                cell.configure(for: recipe)
                return cell
                
            }
            else if userRecipesArray.count > 0 && searchFilterSegmentedControl.selectedSegmentIndex == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.userRecipeCell, for: indexPath) as! UserRecipeCell
                let recipe = userRecipesArray[indexPath.row]
                cell.configure(for: recipe)
                return cell
            }
            else {
                let cell = UITableViewCell()
                cell.isHidden = true
                return cell
            }
        } // end of outer else
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if (recipesArray.count == 0 && userRecipesArray.count == 0) || isLoading {
            return nil
        }
        else {
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if recipesArray.count > 0 {
            let recipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
            selectedIndexPath = indexPath
            performSegue(withIdentifier: "RecipeDetailSegue", sender: recipeCell)
        }
        else {
            let userRecipeCell = tableView.dequeueReusableCell(withIdentifier: "UserRecipeCell", for: indexPath)
            selectedIndexPath = indexPath
            performSegue(withIdentifier: "RecipeDetailSegue", sender: userRecipeCell)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

// MARK: - Search Bar Delegate

extension RecipeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            var searchRecipesURL: URL
            if searchFilterSegmentedControl.selectedSegmentIndex == 0 {
                searchRecipesURL = recipesURL(searchText: searchBar.text!)
                searchRecipes(forEndpoint: searchRecipesURL)
            }
            else if searchFilterSegmentedControl.selectedSegmentIndex == 1 {
                isLoading = true
                hasSearched = true
                getUserRecipes { data in
                    self.userRecipesArray = data
                    self.isLoading = false
                    self.spinner?.stopAnimating()
                    self.userRecipesArray = self.userRecipesArray.filter({ recipeDict in
                        var name = recipeDict["name"] as! String
                        name = name.lowercased()
                        return name.contains((searchBar.text!).lowercased())
                    })
                    if self.userRecipesArray.count > 0 {
                        self.hasSearched = false
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

