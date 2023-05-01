//
//  LoginViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/27/23.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var appLogoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupSegueButton: UIButton!
    
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
        loginButton.tintColor = appBackgroundColor
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
    
    func loginUser() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error signing in user: \(error)")
                let alert = UIAlertController(title: "Login Failed", message: "Please provide a valid email and password", preferredStyle: .alert)
                presentAlert(alert, for: strongSelf)
            }
            else {
                strongSelf.setUpMainView()
            }
            
        }
    }

    @IBAction func login(_ sender: Any) {
        
        guard !emailTextField.text!.isEmpty else {
            let alert = UIAlertController(title: "", message: "Email cannot be empty", preferredStyle: .alert)
            presentAlert(alert, for: self)
            return
        }
        guard !passwordTextField.text!.isEmpty else {
            let alert = UIAlertController(title: "", message: "Password cannot be empty", preferredStyle: .alert)
            presentAlert(alert, for: self)
            return
        }
        
        loginUser()
        // Make the tab bar controller the new root controller and pass coredata managed object context to it
    }
    
    @IBAction func goToSignup(_ sender: Any) {
        performSegue(withIdentifier: "SignupSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignupSegue" {
            let signupVC = segue.destination as! SignupViewController
            signupVC.managedObjectContext = managedObjectContext
            signupVC.window = window
            signupVC.db = db
        }
    }
}
