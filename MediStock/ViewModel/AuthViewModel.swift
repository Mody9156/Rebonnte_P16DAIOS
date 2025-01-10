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
    @Published var id : String? = nil


    init(session : SessionStore = SessionStore() ){
        self.session = session
    }
    
    func login(email:String, password:String){
        session.signIn(email: email, password: password){ result in
            switch result {
            case .success(let user):
                print("Utilisateur créé avec succès : \(user.email ?? "inconnu")")
            case .failure(let error):
                self.messageError = self.session.messageError
                print("Erreur lors de la création de l'utilisateur : \(error.localizedDescription)")

            }
        }
        
    }
    
    func createdNewUser(email: String, password: String){
        session.signUp(email: email, password: password){ result in
            switch result {
            case .success(let user):
                print("Utilisateur créé avec succès : \(user.email ?? "inconnu")")
            case .failure(let error):
                self.messageError = self.session.messageError
                print("Erreur lors de la création de l'utilisateur : \(error.localizedDescription)")

            }
        }
    }
    
    func changeStatus() {
        session.listen { result in
            self.id =  result?.uid
        }
    }
    
}
