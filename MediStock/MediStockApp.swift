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
    @StateObject var viewModelManager = ViewModelManager()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Group {
                    if viewModelManager.isAuthenticated {
                        MainTabView()
                    } else {
                        LoginView()
                    }
                }
                
            }
            //
            //
            //            ContentView()
            //                .environmentObject(sessionStore)
        }
    }
}
