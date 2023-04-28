//
//  RecipeResult.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import Foundation
import UIKit

class Recipes: Codable {
    let recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipes = "meals"
    }
}

class Recipe: Codable, CustomStringConvertible {
    let id: String?
    let name: String?
    let category: String?
    var instructions: String?
    var youtubeURL: String?
    var origin: String?
    let imageURL: String?
    let ingredient1: String?
    let ingredient2: String?
    let ingredient3: String?
    let ingredient4: String?
    let ingredient5: String?
    let ingredient6: String?
    let ingredient7: String?
    let ingredient8: String?
    let ingredient9: String?
    let ingredient10: String?
    let ingredient11: String?
    let ingredient12: String?
    let ingredient13: String?
    let ingredient14: String?
    let ingredient15: String?
    let ingredient16: String?
    let ingredient17: String?
    let ingredient18: String?
    let ingredient19: String?
    let ingredient20: String?
    let measurement1: String?
    let measurement2: String?
    let measurement3: String?
    let measurement4: String?
    let measurement5: String?
    let measurement6: String?
    let measurement7: String?
    let measurement8: String?
    let measurement9: String?
    let measurement10: String?
    let measurement11: String?
    let measurement12: String?
    let measurement13: String?
    let measurement14: String?
    let measurement15: String?
    let measurement16: String?
    let measurement17: String?
    let measurement18: String?
    let measurement19: String?
    let measurement20: String?
    
    internal var description: String {
        return "\nResult - Name: \(String(describing: name)), ID: \(String(describing: id)), ImageURL: \(String(describing:imageURL)), Instructions: \(String(describing: instructions)), \nIngredients: \(String(describing:ingredient1)), \(String(describing: ingredient2)), \(String(describing: ingredient3)), \(String(describing:ingredient4)), \(String(describing: ingredient5))"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case id = "idMeal"
        case category = "strCategory"
        case instructions = "strInstructions"
        case youtubeURL = "strYoutube"
        case origin = "strArea"
        case imageURL = "strMealThumb"
        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"
        case measurement1 = "strMeasure1"
        case measurement2 = "strMeasure2"
        case measurement3 = "strMeasure3"
        case measurement4 = "strMeasure4"
        case measurement5 = "strMeasure5"
        case measurement6 = "strMeasure6"
        case measurement7 = "strMeasure7"
        case measurement8 = "strMeasure8"
        case measurement9 = "strMeasure9"
        case measurement10 = "strMeasure10"
        case measurement11 = "strMeasure11"
        case measurement12 = "strMeasure12"
        case measurement13 = "strMeasure13"
        case measurement14 = "strMeasure14"
        case measurement15 = "strMeasure15"
        case measurement16 = "strMeasure16"
        case measurement17 = "strMeasure17"
        case measurement18 = "strMeasure18"
        case measurement19 = "strMeasure19"
        case measurement20 = "strMeasure20"
    }
}

// MARK: - FIX Spoonacular Model

/*class Recipe: Codable, CustomStringConvertible {
    var name: String?
    var id: Int?
    var imageURL: String?
    var description: String {
        return "\nResult - Name: \(name), ID: \(id), ImageURL: \(imageURL)"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case id = "id"
        case imageURL = "image"
    }
}*/




/*class RecipeInfoResultArray: Decodable {
    var totalResults: Int?
    var results: RecipeInfo
    
    required init(from decoder: Decoder) throws {
        results = try decoder.unkeyedContainer() as! RecipeInfo
    }
}

class RecipeInfo: Codable, CustomStringConvertible {
    var id: Int?
    var name: String?
    var imageURL: String?
    var healthy: Bool?
    /*var healthScore: Int?
    var cookTime: Int?
    var summary: String?
    var pricePerServing: Float?
    var numServings: Int?*/
    //var instructionDetails: Array?
    var description: String {
        return "\nResult - Name: \(name), ID: \(id), ImageURL: \(imageURL), healthy: \(healthy)"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case id = "id"
        case imageURL = "image"
        case healthy = "veryHealthy"
        /*case healthScore = "healthScore"
        case cookTime = "readyInMinutes"
        case summary = "summary"
        case pricePerServing = "pricePerServing"
        case numServings = "servings"*/
        //case instructionDetails = "analyzedInstructions"
    }
}*/
