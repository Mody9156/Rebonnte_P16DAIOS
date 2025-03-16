//
//  AuthViewModel.swift
//  pack
//
//  Created by KEITA on 09/01/2025.
//

import Foundation

enum ShowErrors : Error {
    case disableAutoLoginThrowError
    case changeStatusThrowError
    case loginThrowError
    case createdNewUserThrowError
}

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
    
    @MainActor
    func login(email:String, password:String) async throws {
        do {
            let user = try await session.signIn(email: email, password: password)
            UserDefaults.standard.set(user.email, forKey: "email")
            self.messageError = ""
            onLoginSucceed?()
        }catch{
            self.messageError = "Erreur lors de la connection de l'utilisateur"
            throw ShowErrors.loginThrowError
        }
    }
    
    func createdNewUser(email: String, password: String) async throws {
        do{
            _ = try await session.signUp(email: email, password: password)
            self.messageError = ""
        }catch{
            self.messageError = "Erreur lors de la création de l'utilisateur"
            throw ShowErrors.createdNewUserThrowError
        }
    }
    
    func changeStatus() async throws {
        do{
            try await session.listen()
        }catch{
            throw ShowErrors.changeStatusThrowError
        }
    }
    
    func disableAutoLogin() async throws {
        do{
            try await session.disableAutoLogin()

        }catch{
            throw ShowErrors.disableAutoLoginThrowError
        }
    }
    
    func saveAutoConnectionState(_ state:Bool){
       return UserDefaults.standard.set(state, forKey: "autoLogin")
    }
    
    func loadAutoConnectionState() -> Bool{
        UserDefaults.standard.bool(forKey: "autoLogin")
        
    }
}
