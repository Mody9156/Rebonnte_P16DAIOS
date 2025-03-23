//
//  MockAuthViewModel.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//

@testable import pack
import Foundation

class SaveAutoUser {
    var saveUser : [String:Any] = [:]
    
    func set(_ value: Any?, forKey Key : String) {
        saveUser[Key] = value
    }
    
    func bool(forKey Key : String) -> Bool {
       return saveUser[Key] as? Bool ?? false
    }
}

class MockAuthViewModel : AuthViewModelProtocol{
    private var saveUser : SaveAutoUser
    var isAuthenticated: Bool = false
    var messageError: String = ""
    var onLoginSucceed: (() -> Void)?
    
    init(saveUser: SaveAutoUser) {
        self.saveUser = saveUser
    }
    
    func login(email: String, password: String) async throws {
        if email == "joe@gmail.com" && password == "123456" {
            isAuthenticated = true
            messageError = ""
        }else {
            messageError = "Erreur lors de la connexion"
            throw ShowErrors.loginThrowError
        }
    }
    
    func createdNewUser(email: String, password: String) async throws {
        
        if email != "joe@gmail.com" && password != "123456" {
            messageError = ""
        }else {
            messageError = "Erreur lors de la création de l'utilisateur"
            throw ShowErrors.createdNewUserThrowError
        }
    }
    
    func changeStatus() async throws {
        if isAuthenticated {
            messageError = "erreur lors de la persistance de donné de l'utilisateur"
            throw ShowErrors.changeStatusThrowError
        }
    }
    
    func disableAutoLogin() async throws {
        if isAuthenticated {
            messageError = "erreur de deconnexion"
            throw ShowErrors.disableAutoLoginThrowError
        }
    }
    
    func saveAutoConnectionState(_ state: Bool) {
        
        saveUser.set(saveUser, forKey: "autoConnection")
    }
    
    func autotoLogin() async throws {
        
    }

}
