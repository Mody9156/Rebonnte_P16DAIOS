//
//  MockAuthViewModel.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//

@testable import pack
import Foundation

class MockAuthViewModel : AuthViewModelProtocol{
    var isAuthenticated: Bool = false
    var messageError: String = ""
    var onLoginSucceed: (() -> Void)?
    var saveEmail : String?
    var savePassword : String?
    
    func login(email: String, password: String) async throws {
        isAuthenticated = true
        
        if email == "joe@gmail.com" && password == "123456" {
            isAuthenticated = true
            messageError = ""
            saveEmail = email
            savePassword = password
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
        if state {
            messageError = ""
            UserDefaults.standard.set(state, forKey: "autoConnection")
        }else{
            messageError = "Veuillez vérifier que le bouton de connection automatique est coché"
        }
    }
    
    func autotoLogin() async throws {

        guard let email = UserDefaults.standard.string(forKey: "email"),
              let password = UserDefaults.standard.string(forKey: "password") else {
            messageError = "Veuillez remplir tous les champs"
            return
        }
      
        guard !email.isEmpty, !password.isEmpty else {
            messageError = "Veuillez remplir tous les champs"
            saveEmail = nil
            savePassword = nil
            return
        }
        saveEmail = email
        savePassword = password
        messageError = ""

        do {
            try await login(email: email, password: password)
        } catch {
            messageError = "Erreur lors de la connexion (sauvegarde echouée)"
        }
    }
}
