//
//  RecipeResult.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import Foundation

class RecipeResultArray: Codable {
    var resultCount: Int? = 0
    var results: [Recipe]
}

class Recipe: Codable {
    var name: String? = ""
    var url: String? = ""
    //var weight: Int? = 0
}
