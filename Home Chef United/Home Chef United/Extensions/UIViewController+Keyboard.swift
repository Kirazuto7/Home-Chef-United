//
//  UIViewController+Keyboard.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/23/23.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
        
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: - Adjust view when Show/Hide Keyboard occurs
    // SOURCE: - https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
    func addKeyboardNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = keyboardSize.height * 2 - self.view.frame.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the view when keyboard disappears
            self.view.frame.origin.y = 0
    }
}

