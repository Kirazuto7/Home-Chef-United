//
//  FavoriteRecipe+CoreDataClass.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/23/23.
//
//

import Foundation
import CoreData
import UIKit

@objc(FavoriteRecipe)
public class FavoriteRecipe: NSManagedObject {
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoURL: URL {
        assert(photoID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!.intValue).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        return currentID
    }
    
    func removePhotoFile() {
        if hasPhoto {
            do {
                try FileManager.default.removeItem(at: photoURL)
            }
            catch {
                print("Error removing file: \(error)")
            }
        }
    }
}

