//
//  api.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import Foundation

// MARK: - Endpoints
let recipeBaseURL = "https://www.themealdb.com/api/json/v1/1/"

// MARK: - URLs
func recipesURL(searchText: String) -> URL {
    let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let urlString = "\(recipeBaseURL)search.php?s=\(encodedText)"
    let url = URL(string: urlString)!
    return url
}

func randomRecipeURL() -> URL {
    let urlString = "\(recipeBaseURL)random.php"
    return URL(string: urlString)!
}



