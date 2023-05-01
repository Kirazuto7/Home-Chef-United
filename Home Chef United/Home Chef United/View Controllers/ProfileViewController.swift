//
//  ProfileViewController.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/28/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CoreData

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var signoutButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mostRecentRecipeView: UIView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeDateSavedLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var mostRecentRecipePlaceholderLabel: UILabel!
    @IBOutlet var passwordTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var saveButton: UIButton!
    
    let defaults = UserDefaults.standard // Use to retrieve most recently saved recipe data
    var managedObjectContext: NSManagedObjectContext!
    var window: UIWindow!
    var db: Firestore!
    var editMode: Bool = false
    
    var user: User? = Auth.auth().currentUser
    var gradient: CAGradientLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        setupProfileView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let mostRecentRecipeTitle = defaults.object(forKey: MOST_RECENT_RECIPE_TITLE_KEY) as? String, let mostRecentRecipeImage = defaults.object(forKey: MOST_RECENT_RECIPE_IMAGE_KEY) as? String, let mostRecentRecipeDate = defaults.object(forKey: MOST_RECENT_RECIPE_DATE_KEY) as? Date {
            mostRecentRecipePlaceholderLabel.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let date = dateFormatter.string(from: mostRecentRecipeDate)
            
            recipeNameLabel.text = mostRecentRecipeTitle
            recipeDateSavedLabel.text = "Date Saved: \(date)"
            recipeImageView.downloadImage(url: URL(string: mostRecentRecipeImage)!)
            mostRecentRecipeView.clipsToBounds = true
            mostRecentRecipeView.layer.cornerRadius = 5
            setAppBackground(forView: mostRecentRecipeView)
        }
        else {
            mostRecentRecipePlaceholderLabel.isHidden = true
        }
    }
  
    func setupProfileView() {
        navigationItem.title = "Profile"
        saveButton.tintColor = appBackgroundColor
        editButton.tintColor = UIColor.link
        mostRecentRecipeView.isHidden = false
        passwordLabel.isHidden = true
        saveButton.isHidden = true
        
        nameTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        
        nameTextField.borderStyle = .none
        emailTextField.borderStyle = .none
        nameTextField.textAlignment = .center
        emailTextField.textAlignment = .center
        
        nameTextField.borderLayerStyle(cgColor: UIColor.clear.cgColor, borderWidth: 0, cornerRadius: 0)
        emailTextField.borderLayerStyle(cgColor: UIColor.clear.cgColor, borderWidth: 0, cornerRadius: 0)
        passwordLabel.layer.borderWidth = 0
        passwordLabel.layer.borderColor = UIColor.clear.cgColor
        passwordLabel.layer.cornerRadius = 0
        
        nameTextField.text = user?.displayName
        emailTextField.text = user?.email
    }
    
    func setupEditView() {
        let textFieldColor: CGColor = (appBackgroundColor).cgColor
        let textFieldBorderWidth: CGFloat = 2
        let textFieldCornerRadius: CGFloat = 17

        navigationItem.title = "Edit Profile"
        editButton.tintColor = .red
        mostRecentRecipeView.isHidden = true
        passwordLabel.isHidden = false
        saveButton.isHidden = false
        
        nameTextField.isUserInteractionEnabled = true
        emailTextField.isUserInteractionEnabled = true
        passwordLabel.isUserInteractionEnabled = true
        
        nameTextField.textAlignment = .natural
        emailTextField.textAlignment = .natural
        
        nameTextField.layer.isHidden = false
        emailTextField.layer.isHidden = false
        nameTextField.borderLayerStyle(cgColor: textFieldColor, borderWidth: textFieldBorderWidth, cornerRadius: textFieldCornerRadius)
        emailTextField.borderLayerStyle(cgColor: textFieldColor, borderWidth: textFieldBorderWidth, cornerRadius: textFieldCornerRadius)
        passwordLabel.layer.borderWidth = textFieldBorderWidth
        passwordLabel.layer.borderColor = textFieldColor
        passwordLabel.layer.cornerRadius = textFieldCornerRadius
        
        nameTextField.text = user?.displayName
        emailTextField.text = user?.email
    }
    
    func signoutUser() {
        do {
            try Auth.auth().signOut()
            goToLoginScreen()
        }
        catch let signOutError as NSError {
            print("Error signing user out: \(signOutError)")
            let alert = UIAlertController(title: "Error!", message: "There was an error signing out.", preferredStyle: .alert)
            presentAlert(alert, for: self)
        }
    }
    
    func goToLoginScreen() {
        window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let loginController = window!.rootViewController as! LoginViewController
        loginController.managedObjectContext = managedObjectContext
        loginController.window = window
        loginController.db = db
    }
    
    // MARK: - IBOutlet Actions
    
    @IBAction func signout(_ sender: Any) {
        let alert = UIAlertController(title: "Signout", message: "Are you sure you would like to sign out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .destructive) { _ in
            self.signoutUser()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func switchProfileEditMode(_ sender: Any) {
        editMode = !editMode
        
        if editMode {
            setupEditView()
        }
        else {
            setupProfileView()
        }
    }
    
    
    @IBAction func saveEditChanges(_ sender: Any) {
        let errorAlert = UIAlertController(title: "Error", message: "There was an error saving your changes", preferredStyle: .alert)
        let changeRequest = user?.createProfileChangeRequest()
        
        if nameTextField.text != user?.displayName {
            changeRequest?.displayName = nameTextField.text!
            changeRequest?.commitChanges(completion: { error in
                if error != nil {
                    presentAlert(errorAlert, for: self)
                }
            })
        }
        
        if passwordLabel.text != "New Password" {
            user?.updatePassword(to: passwordLabel.text!, completion: { error in
                if error != nil {
                    presentAlert(errorAlert, for: self)
                }
            })
        }
        
        if emailTextField.text != user?.email {
            user?.updateEmail(to: emailTextField.text!, completion: { error in
                if error != nil {
                    presentAlert(errorAlert, for: self)
                }
            })
        }
    }
    
    
    @IBAction func inputNewEmail(_ sender: Any) {

        guard validateEmail(emailTextField.text!) else {
            let errorAlert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address", preferredStyle: .alert)
            emailTextField.text = user?.email
            presentAlert(errorAlert, for: self)
            return
        }
    }
    
    @IBAction func inputNewPassword(_ sender: Any) {
        verifyPassword()
    }
    
    func verifyPassword() {
        let alert = UIAlertController(title: "Verify Password", message: "Please input your current password to change your password", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { textField in
            textField.placeholder = "Enter your current password"
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter your new password"
        }
        let ok = UIAlertAction(title: "Ok", style: .default) { [weak alert] (_) in
            let currentPasswordTextField = alert?.textFields![0]
            let newPassTextField = alert?.textFields![1]
            let currentPassword = currentPasswordTextField!.text
            let newPassword = newPassTextField!.text
            
            guard currentPassword != nil else { return }
            guard newPassword != nil else { return }
            
            let credential = EmailAuthProvider.credential(withEmail: self.user!.email!, password: currentPassword!)
            self.user?.reauthenticate(with: credential, completion: { _, error in
                if error != nil {
                    let errorAlert = UIAlertController(title: "Incorrect Password", message: "The password is invalid...Please try again", preferredStyle: .alert)
                    presentAlert(errorAlert, for: self)
                }
                else {
                    guard currentPasswordTextField?.text != newPassTextField?.text else {
                        let errorAlert = UIAlertController(title: "Invalid Password", message: "The new password cannot be the same as the current password", preferredStyle: .alert)
                        presentAlert(errorAlert, for: self)
                        return
                    }
                    
                    guard self.validatePasswordLength(passwordText: newPassword!) else { return }
                    
                    self.passwordLabel.text = newPassword!
                }
            })
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func validatePasswordLength(passwordText pText: String) -> Bool {
        let alert = UIAlertController(title: "Invalid Password", message: "Password must contain at least 6 characters and 1 special character", preferredStyle: .alert)
        
        var password = pText
        let specialCharset = CharacterSet.punctuationCharacters
        let range = password.rangeOfCharacter(from: specialCharset)
        password = password.replacingOccurrences(of: " ", with: "")
 
         guard password.count >= 6 && range != nil else {
            presentAlert(alert, for: self)
            return false
        }
        return true
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
