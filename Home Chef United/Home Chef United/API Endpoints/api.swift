//
//  api.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import Foundation

let MOST_RECENT_RECIPE_TITLE_KEY = "MOST_RECENT_RECIPE_TITLE"
let MOST_RECENT_RECIPE_IMAGE_KEY = "MOST_RECENT_RECIPE_IMAGE"
let MOST_RECENT_RECIPE_DATE_KEY = "MOST_RECENT_RECIPE_DATE"

// MARK: - Endpoints
//let recipeBaseURL = "https://api.spoonacular.com/recipes/"
let recipeBaseURL = "https://www.themealdb.com/api/json/v1/1/"

// MARK: - Keys
/*var recipeApiKey: String {
    get {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "RECIPE_API_KEY") as? String else {
            fatalError("Couldn't find the api key in 'Info.plist'.")
        }
        return value
    }
}
}*/

// MARK: - URLs
func recipesURL(searchText: String) -> URL {
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    //let urlString = "\(recipeBaseURL)complexSearch?query=\(encodedText)&number=10&apiKey=\(recipeApiKey)"
    let urlString = "\(recipeBaseURL)search.php?s=\(encodedText)"
    let url = URL(string: urlString)!
    return url
}

func randomRecipeURL() -> URL {
    let urlString = "\(recipeBaseURL)random.php"
    return URL(string: urlString)!
}
/*func recipesInfoURL(recipeIDs: [Int]) -> URL {
    let ids = recipeIDs.map{String($0)}.joined(separator: ",")
    let urlString = "\(recipeBaseURL)informationBulk?ids=\(ids)&number=10&apiKey=\(recipeApiKey)"
    let url = URL(string: urlString)!
    return url
}*/


