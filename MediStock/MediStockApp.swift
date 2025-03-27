//
//  MediStockApp.swift
//  MediStock
//
//  Created by Vincent Saluzzo on 28/05/2024.
//

import SwiftUI

@main
struct MediStockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var sessionStore = SessionStore()
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false
    @AppStorage("hasUserChosenMode") private var hasUserChosenMode : Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            AuthenticationManagerView()
                .environmentObject(sessionStore)
                .preferredColorScheme(hasUserChosenMode ? (toggleDarkMode ? .dark : .light) : colorScheme)
        }
    }
}
