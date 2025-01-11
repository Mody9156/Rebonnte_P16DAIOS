//
//  ViewModelManager.swift
//  pack
//
//  Created by KEITA on 11/01/2025.
//

import Foundation

class ViewModelManager:ObservableObject {
    @Published var isAuthenticated : Bool

    init(){
        self.isAuthenticated = false
    }
    
    var authViewModel : AuthViewModel {
        return AuthViewModel { [weak self] in
            self?.isAuthenticated = true
        }
    }
    
}
