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
    @Published var session: AuthViewModelProtocol
    @Published var messageError : String = ""
    @Published var onLoginSucceed : (()-> Void)?
    @Published var isAuthenticated : Bool = false
    
    init(session : AuthViewModelProtocol = ManagementAuthViewModel(),onLoginSucceed : (()-> Void)? = nil ){
        self.session = session
        self.onLoginSucceed = onLoginSucceed

        
    }
    
    @MainActor
    func login(email:String, password:String) async throws {
        do {
             try await session.login(email: email, password: password)
            isAuthenticated = session.isAuthenticated
            self.messageError = ""
        }catch{
            self.messageError = "Erreur lors de la connection de l'utilisateur"
            isAuthenticated = false
            throw ShowErrors.loginThrowError
        }
    }
    
    func createdNewUser(email: String, password: String) async throws {
        do{
            _ = try await session.createdNewUser(email: email, password: password)
            self.messageError = ""
        }catch{
            self.messageError = "Erreur lors de la création de l'utilisateur"
            throw ShowErrors.createdNewUserThrowError
        }
    }
    
    func changeStatus() async throws {
        do{
            try await session.changeStatus()
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
    
    func autotoLogin() async throws {
        if let saveEmail = UserDefaults.standard.string(forKey: "email"),
           let savePassword = UserDefaults.standard.string(forKey: "password"){
            try await session.login(email: saveEmail, password: savePassword)
        }
    }
}
