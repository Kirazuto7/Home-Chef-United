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

    @NSManaged public var date: Date
    @NSManaged public var ingredients: [String]
    @NSManaged public var instructions: [String]
    @NSManaged public var measurements: [String:String]?
    @NSManaged public var origin: String?
    @NSManaged public var prepTime: Double
    @NSManaged public var title: String
    @NSManaged public var youtubeURL: String?
    @NSManaged public var sectionCategory: String
    @NSManaged public var photoID: NSNumber?
    @NSManaged public var photoString: String?
    @NSManaged public var author: String?
}

extension FavoriteRecipe : Identifiable {

}
