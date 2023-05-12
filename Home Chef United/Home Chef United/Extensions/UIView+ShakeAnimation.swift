//
//  UIView+ShakeAnimation.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/26/23.
//

import Foundation
import UIKit

extension UIView {
    
    // SOURCE: - https://stackoverflow.com/questions/27987048/shake-animation-for-uitextfield-uiview-in-swift
    func shakeAnimation(durationOf duration: Double, repeatNumTimes repeatCount: Float) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
