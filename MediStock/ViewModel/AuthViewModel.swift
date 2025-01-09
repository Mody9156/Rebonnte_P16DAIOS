//
//  AuthViewModel.swift
//  pack
//
//  Created by KEITA on 09/01/2025.
//

import Foundation

class AuthViewModel : ObservableObject {
    @Published var session: SessionStore
    
    init(session : SessionStore = SessionStore()){
        self.session = session
    }
    
    func login(email:String, password:String){
        
    }
    
    
    
}
