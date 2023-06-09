//
//  Functions.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import Foundation
import UIKit

// MARK: - Keys/Global Variables
let MOST_RECENT_RECIPE_TITLE_KEY = "MOST_RECENT_RECIPE_TITLE"
let MOST_RECENT_RECIPE_IMAGE_KEY = "MOST_RECENT_RECIPE_IMAGE"
let MOST_RECENT_RECIPE_DATE_KEY = "MOST_RECENT_RECIPE_DATE"
let appBackgroundColor = UIColor(red: 253/255, green: 179/255, blue: 130/255, alpha: 1)
let appTextColor = UIColor.black

// MARK: - Group of Global Helper Functions

// Finds the path to the app's document directory
let applicationDocumentsDirectory: URL = {
  let paths = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask)
  return paths[0]
}()

let dataSaveFailedNotification = Notification.Name(
  rawValue: "DataSaveFailedNotification")
    func fatalCoreDataError(_ error: Error) {

        print("*** Fatal error: \(error)")
        NotificationCenter.default.post(
            name: dataSaveFailedNotification,
            object: nil)
}

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

func presentAlert(_ alert: UIAlertController, for viewController: UIViewController) {
    viewController.present(alert, animated: true)
    let delay = DispatchTime.now() + 2
    DispatchQueue.main.asyncAfter(deadline: delay) {
        alert.dismiss(animated: true)
    }
}

func performURLRequest(with url: URL) -> String? {
    do{
        return try String(contentsOf: url, encoding: .utf8)
    }
    catch {
        print("Error: \(error.localizedDescription)")
        return nil
    }
}

func taskErrorCheck(response: URLResponse?, error: Error?) -> Bool {
    // Check if there is an error with the request
    if let error = error as NSError?, error.code == -999  {
        print("ERROR: \(error.localizedDescription)")
        return false
    }
    
    // Check https response status
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode)
    else {
        print(String(describing: (response)))
        return false
    }
    // Check the response type is json data
    guard let mime = response?.mimeType, mime == "application/json"
    else {
        print("Response Type is not JSON!")
        return false
    }
    
    return true
}

func setupBackgroundView(for view: UIView, with image: UIImage) {
    let imageView = UIImageView(frame: view.bounds)
    imageView.image = image
    imageView.contentMode = .scaleToFill
    imageView.clipsToBounds = true
    imageView.center = view.center
    view.addSubview(imageView)
    view.sendSubviewToBack(imageView)
}

// SOURCE: - https://stackoverflow.com/questions/24380535/how-to-apply-gradient-to-background-view-of-ios-swift-app
func setAppBackground(forView view: UIView) {
    let gradient = CAGradientLayer()
    let topColor = CGColor(red: 255/255, green: 126/255, blue: 95/255, alpha: 1)
    let bottomColor = CGColor(red: 254/255, green: 180/255, blue: 123/255, alpha: 1)
    gradient.frame = view.bounds
    gradient.locations = [0.0, 1.0]
    gradient.colors = [topColor, bottomColor]
    view.layer.insertSublayer(gradient, at: 0)
}

// SOURCE: - https://stackoverflow.com/questions/3454356/uiimage-from-calayer-in-ios
func gradientImage(fromLayer layer: CALayer) -> UIImage {
    UIGraphicsBeginImageContext(layer.frame.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

func addCancelToTextFields(forTextFields textFields: [UITextField]) {
    
    for textField in textFields {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let cancel = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
            textField.resignFirstResponder()
        }), menu: nil)
        toolBar.setItems([cancel], animated: true)
        textField.inputAccessoryView = toolBar
    }
}


// MARK: - Helper Functions for Details regarding Recipes

// Returns map: key = ingredient # and value = ingredients and their measurements
func getRecipeIngredients(for recipe: Recipe) -> [Int:(String,String)] {
    var ingredients = [Int:(String,String)]()
    
  
    if recipe.ingredient1 != "" && recipe.ingredient1 != nil {
        ingredients[1] = (recipe.ingredient1!, recipe.measurement1!)
    }
    if recipe.ingredient2 != "" && recipe.ingredient2 != nil {
        ingredients[2] = (recipe.ingredient2!, recipe.measurement2!)
    }
    if recipe.ingredient3 != "" && recipe.ingredient3 != nil {
        ingredients[3] = (recipe.ingredient3!, recipe.measurement3!)
    }
    if recipe.ingredient4 != "" && recipe.ingredient4 != nil {
        ingredients[4] = (recipe.ingredient4!, recipe.measurement4!)
    }
    if recipe.ingredient5 != "" && recipe.ingredient5 != nil {
        ingredients[5] = (recipe.ingredient5!, recipe.measurement5!)
    }
    if recipe.ingredient6 != "" && recipe.ingredient6 != nil {
        ingredients[6] = (recipe.ingredient6!, recipe.measurement6!)
    }
    if recipe.ingredient7 != "" && recipe.ingredient7 != nil {
        ingredients[7] = (recipe.ingredient7!, recipe.measurement7!)
    }
    if recipe.ingredient8 != "" && recipe.ingredient8 != nil {
        ingredients[8] = (recipe.ingredient8!, recipe.measurement8!)
    }
    if recipe.ingredient9 != "" && recipe.ingredient9 != nil {
        ingredients[9] = (recipe.ingredient9!, recipe.measurement9!)
    }
    if recipe.ingredient10 != "" && recipe.ingredient10 != nil {
        ingredients[10] = (recipe.ingredient10!, recipe.measurement10!)
    }
    if recipe.ingredient11 != "" && recipe.ingredient11 != nil {
        ingredients[11] = (recipe.ingredient11!, recipe.measurement11!)
    }
    if recipe.ingredient12 != "" && recipe.ingredient12 != nil {
        ingredients[12] = (recipe.ingredient12!, recipe.measurement12!)
    }
    if recipe.ingredient13 != "" && recipe.ingredient13 != nil {
        ingredients[13] = (recipe.ingredient13!, recipe.measurement13!)
    }
    if recipe.ingredient14 != "" && recipe.ingredient14 != nil {
        ingredients[14] = (recipe.ingredient14!, recipe.measurement14!)
    }
    if recipe.ingredient15 != "" && recipe.ingredient15 != nil {
        ingredients[15] = (recipe.ingredient15!, recipe.measurement15!)
    }
    if recipe.ingredient16 != "" && recipe.ingredient16 != nil {
        ingredients[16] = (recipe.ingredient16!, recipe.measurement16!)
    }
    if recipe.ingredient17 != "" && recipe.ingredient17 != nil {
        ingredients[17] = (recipe.ingredient17!, recipe.measurement17!)
    }
    if recipe.ingredient18 != "" && recipe.ingredient18 != nil {
        ingredients[18] = (recipe.ingredient18!, recipe.measurement18!)
    }
    if recipe.ingredient19 != "" && recipe.ingredient19 != nil {
        ingredients[19] = (recipe.ingredient19!, recipe.measurement19!)
    }
    if recipe.ingredient20 != "" && recipe.ingredient20 != nil {
        ingredients[20] = (recipe.ingredient20!, recipe.measurement20!)
    }
    return ingredients
}

func getRecipeInstructionSteps(for recipe: Recipe) -> [String] {
    var instructions = (recipe.instructions?.replacingOccurrences(of: "STEP 1", with: ""))!
    for i in 2...10 {
        instructions = instructions.replacingOccurrences(of: "STEP \(i)", with: "")
    }
    instructions = instructions.replacingOccurrences(of: "\r\n", with: "")
    return instructions.convertToSentences()
}

func convertToYoutubeID(for recipe: Recipe) -> String {
    guard !recipe.youtubeURL!.isEmpty else { return "" }
    return recipe.youtubeURL?.components(separatedBy: "=")[1] ?? ""
}


