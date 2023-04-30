//
//  UILabel+Padding.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/30/23.
//

import Foundation
import UIKit

class PaddingLabel: UILabel {
    let padding = UIEdgeInsets(top: 0, left: 10 , bottom: 0, right: 0)
    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
