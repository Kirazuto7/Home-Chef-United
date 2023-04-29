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
    
    var managedObjectContext: NSManagedObjectContext!
    var window: UIWindow!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
