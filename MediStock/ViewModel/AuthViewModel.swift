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
    @Published var onLoginSucceed : (()-> Void)?
    
    var isAuthenticated: Bool {
           session.isAuthenticated
       }
       
       var messageError: String {
           session.messageError
       }
    
    init(session : AuthViewModelProtocol = ManagementAuthViewModel(),onLoginSucceed : (()-> Void)? = nil ){
        self.session = session
        self.onLoginSucceed = onLoginSucceed

        
    }
    
    @MainActor
    func login(email:String, password:String) async throws {
        do {
             try await session.login(email: email, password: password)
        }catch{
            throw ShowErrors.loginThrowError
        }
    }
    
    func createdNewUser(email: String, password: String) async throws {
        do{
            _ = try await session.createdNewUser(email: email, password: password)
        }catch{
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
