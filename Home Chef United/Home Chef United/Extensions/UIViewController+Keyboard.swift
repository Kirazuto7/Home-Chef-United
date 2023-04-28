//
//  UIViewController+Keyboard.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/23/23.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

