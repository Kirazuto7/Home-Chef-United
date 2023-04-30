//
//  UITextField+Padding.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/30/23.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITextField {
    func borderLayerStyle(cgColor color: CGColor, borderWidth width: CGFloat, cornerRadius radius: CGFloat) {
        self.layer.borderColor = color
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
    }
    
}
