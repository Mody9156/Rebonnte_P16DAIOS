//
//  AuthViewModel.swift
//  pack
//
//  Created by KEITA on 09/01/2025.
//

import Foundation

class AuthViewModel : ObservableObject {
    @Published var session: SessionStore
    @Published var messageError : String = ""
    @Published var user: User?

    init(session : SessionStore = SessionStore(), user: User?){
        self.session = session
    }
    
    func login(email:String, password:String){
        session.signIn(email: email, password: password)
        self.messageError = session.messageError
        self.user = session.session
    }
    
    func createdNewUser(email: String, password: String){
        session.signUp(email: email, password: password)
        self.messageError = session.messageError
    }
    
}
