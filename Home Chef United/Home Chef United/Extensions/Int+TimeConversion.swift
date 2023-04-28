//
//  Int+TimeConversion.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/25/23.
//

import Foundation

extension Int {
    
    func hoursToSeconds() -> Int {
        return self * 3600
    }
    
    func secondsToHours() -> Int {
        return self / 3600
    }
    
    func minutesToSeconds() -> Int {
        return self * 60
    }
    
    func secondsToMinutes() -> Int {
        return self / 60
    }
    
    func secondsToTimeString() -> String {
        let hours = self / 3600
        let minutes = (self / 60) % 60
        let seconds = self % 60
        
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
        else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
