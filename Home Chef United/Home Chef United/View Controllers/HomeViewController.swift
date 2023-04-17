//
//  HomeViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/15/23.
//

import UIKit

class HomeViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchRecipes()
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Oops...", message: "Looks like there was an error fetching data." + "Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - HTTP Method(s)
    
    // Helper function to parse JSON data into a useable format
    func parse(data: Data) -> [Recipe] {
        do{
            let decoder = JSONDecoder()
            let result = try decoder.decode(RecipeResultArray.self, from: data)
            return result.results
        }
        catch {
            print("JSON Error: \(error)")
            showNetworkError()
            return []
        }
    }
    
    func fetchRecipes() {
        let session = URLSession.shared
        let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?query=pasta&maxFat=25&number=2&apiKey=e1b5a7a55edb4bc8916b32ddaa638498")!
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            
            // Check if there is an error with the request
            if error != nil {
                print(error)
                fatalCoreDataError(error!)
                return
            }
            
            // Check https response status
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print(response)
                return
            }
            
            // Check the response type is json data
            guard let mime = response?.mimeType, mime == "application/json"
            else {
                print("Wrong MIME type!")
                return
            }
                        
            // Convert the data to JSON
            /*if let json = try? JSONSerialization.jsonObject(with: data!, options: []){
                print("JSON: ", json)
               
            }*/
            if let data = data {
                if let recipes = self?.parse(data: data) {
                    print(recipes[0].name)
                }
            }
        }
        task.resume()
    }
    
    // MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        return cell
    }
}

