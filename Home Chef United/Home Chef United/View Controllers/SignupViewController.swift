//
//  SignupViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/27/23.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignupViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var managedObjectContext: NSManagedObjectContext!
    var window: UIWindow!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addKeyboardNotificationCenter()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        signupButton.tintColor = appBackgroundColor
        signupButton.titleLabel?.textColor = appBackgroundColor
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        setupBackgroundView(for: self.view, with: UIImage(named: "FoodBackground")!)
    }
    
    func setUpMainView() {
        self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        
        if let tabBarController = window!.rootViewController as? UITabBarController {
            if let viewControllers = tabBarController.viewControllers {
                let recipeNavController = viewControllers[0] as! UINavigationController
                let recipeController = recipeNavController.viewControllers.first as! RecipeViewController
                recipeController.managedObjectContext = managedObjectContext
                recipeController.db = db
                
                let cookbookNavController = viewControllers[1] as! UINavigationController
                let cookbookController = cookbookNavController.viewControllers.first as! CookbookViewController
                cookbookController.managedObjectContext = managedObjectContext
                cookbookController.db = db
                
                let profileNavController = viewControllers[2] as! UINavigationController
                let profileController = profileNavController.viewControllers.first as! ProfileViewController
                profileController.managedObjectContext = managedObjectContext
                profileController.window = window
                profileController.db = db
            }
        }
    }
    
    func validatePassword() {
        let alert = UIAlertController(title: "Invalid Password", message: "Password must contain at least 6 characters and 1 special character", preferredStyle: .alert)
        
        var password = passwordTextField.text ?? ""
        let specialCharset = CharacterSet.punctuationCharacters
        let range = password.rangeOfCharacter(from: specialCharset)
        password = password.replacingOccurrences(of: " ", with: "")
 
         guard password.count >= 6 && range != nil else {
            passwordTextField.text = ""
            presentAlert(alert, for: self)
            return
        }
    }
    
    func signupUser() {
        let email = emailTextField.text!
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            let user = result?.user
            let userID = user?.uid
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { error in
                print("Error saving username: \(error)")
            })
            
            self.db.collection("users").document(userID!).setData([
                "id": userID,
                "email": email,
                "username": username,
                "password":  password
            ]) { error in
                if let error = error {
                    print("Error saving user to database: \(error)")
                    let alert = UIAlertController(title: "Signup Error", message: "There was an issue creating an account for this email. Please try again later or try a different email...", preferredStyle: .alert)
                    presentAlert(alert, for: self)
                }
                else {
                    print("Document successfully created")
                    self.setUpMainView()
                }
            }
            
        }
    }
    
    // MARK: - IBOutlet Actions
    
    @IBAction func inputPassword(_ sender: Any) {
        validatePassword()
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        guard !emailTextField.text!.isEmpty else {
            let alert = UIAlertController(title: "Signup Failed", message: "Please provide a username and min 6 character password", preferredStyle: .alert)
            presentAlert(alert, for: self)
            return
        }
        guard !passwordTextField.text!.isEmpty else {
            let alert = UIAlertController(title: "Signup Failed", message: "Please provide a username and min 6 character password", preferredStyle: .alert)
            presentAlert(alert, for: self)
            return
        }
        
        guard !usernameTextField.text!.isEmpty else {
            let alert = UIAlertController(title: "Signup Failed", message: "Please provide a valid email, username, and password", preferredStyle: .alert)
            presentAlert(alert, for: self)
            return
        }
        
        signupUser()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
