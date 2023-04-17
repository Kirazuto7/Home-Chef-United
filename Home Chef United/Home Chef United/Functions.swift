//
//  Functions.swift
//  Home Chef United
//
//  Created by Jordan Sukhnandan on 4/17/23.
//

import Foundation
import UIKit

// Group of Global Helper Functions 

func afterDelay(_ seconds: Double, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: run)
}

func fatalCoreDataError(_ error: Error) {
    let dataSaveFailedNotification = Notification.Name("DataSaveFailedNotification")
    print("*** Fatal Error: \(error)")
    NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
}

