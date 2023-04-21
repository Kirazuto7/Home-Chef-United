//
//  HomeViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/15/23.
//

import UIKit

class RecipeViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    var recipesArray = [Recipe]()
    var hasSearched = false
    var isLoading = false
    var spinner: UIActivityIndicatorView?
    var recipesDataTask: URLSessionDataTask?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register views for table view cells
        var cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetailSegue" {
            let recipeDetailViewController = segue.destination as! RecipeDetailViewController
            let recipe = recipesArray[selectedIndexPath?.row ?? 0]
            recipeDetailViewController.recipe = recipe
        }
    }
    
    // MARK: - HTTP Method(s)
    // Helper function to parse JSON data into a useable format
    func parseRecipe(data: Data) -> [Recipe] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(Recipes.self, from: data)
            print(result)
            return result.recipes
        }
        catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
    
    func searchRecipes() {
        recipesDataTask?.cancel()
        hasSearched = true
        isLoading = true
        self.tableView.reloadData() // Show the loading cell
        let searchRecipesUrl = recipesURL(searchText: searchBar.text!)
        print(searchRecipesUrl)
        let session = URLSession.shared
        recipesDataTask = session.dataTask(with: searchRecipesUrl) {
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
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 1
        }
        else if recipesArray.count == 0 && hasSearched{
            return 1
        }
        else if recipesArray.count > 0 {//&& recipesInfoArray.count > 0 {
            return recipesArray.count
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
            if recipesArray.count == 0 && hasSearched {
                return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            }
            else if recipesArray.count > 0 {//&& recipesInfoArray.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.recipeCell, for: indexPath) as! RecipeCell
                let recipe = recipesArray[indexPath.row]
                // TO DO: - Determine if recipe is favorited or not from user with api call
                cell.configure(for: recipe, liked: false)
                
                return cell
                
            } // end of inner else
            else {
                let cell = UITableViewCell()
                cell.isHidden = true
                return cell
            }
        } // end of outer else
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if recipesArray.count == 0 || isLoading {
            return nil
        }
        else {
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "RecipeDetailSegue", sender: recipeCell)
    }
    
}

// MARK: - Search Bar Delegate

extension RecipeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            searchRecipes()
        }
    }
}

