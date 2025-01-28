//
//  AppDelegate.swift
//  MediStock
//
//  Created by Vincent Saluzzo on 28/05/2024.
//

import Foundation
import UIKit
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}
