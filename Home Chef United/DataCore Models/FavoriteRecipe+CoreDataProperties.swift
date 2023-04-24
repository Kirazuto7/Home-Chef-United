//
//  FavoriteRecipe+CoreDataProperties.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/23/23.
//
//

import Foundation
import CoreData


extension FavoriteRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        return NSFetchRequest<FavoriteRecipe>(entityName: "FavoriteRecipe")
    }

    @NSManaged public var title: String?
    @NSManaged public var ingredients: NSObject?
    @NSManaged public var measurements: NSObject?
    @NSManaged public var instructions: NSObject?
    @NSManaged public var youtubeURL: String?
    @NSManaged public var date: Date?
    @NSManaged public var prepTime: Double
    @NSManaged public var origin: String?

}

extension FavoriteRecipe : Identifiable {

}
