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
    @Published var onLoginSucceed : (()-> Void)?
    @Published var isAuthenticated : Bool = false
    
    init(session : SessionStore = SessionStore(),onLoginSucceed : (()-> Void)? = nil ){
        self.session = session
        self.onLoginSucceed = onLoginSucceed
        
        session.$session
            .map { $0 != nil }
            .assign(to: &$isAuthenticated)
    }
    
    func login(email:String, password:String){
        session.signIn(email: email, password: password){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.messageError = ""
                    UserDefaults.standard.set(user.email, forKey: "email")
                    print("isAuthenticated : \(self.isAuthenticated)")
                    print("Utilisateur connecté avec succès : \(user.email ?? "inconnu")")
                    self.onLoginSucceed?()
                case .failure(let error):
                    self.messageError = "Erreur lors de la connection de l'utilisateur"
                    print("Erreur lors de la connection de l'utilisateur : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createdNewUser(email: String, password: String){
        session.signUp(email: email, password: password){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.messageError = ""
                    print("Utilisateur créé avec succès : \(user.email ?? "inconnu")")
                case .failure(let error):
                    self.messageError = "Erreur lors de la création de l'utilisateur"
                    print("Erreur lors de la création de l'utilisateur : \(error.localizedDescription)")
                }
            }
        }
    }
    
    func changeStatus() {
        session.listen()
    }
    func disableAutoLogin() async throws {
      try await session.disableAutoLogin()
    }
    
}
