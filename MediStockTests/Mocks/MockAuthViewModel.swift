//
//  MockAuthViewModel.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//
import Testing
@testable import pack
import Foundation

class MockAuthViewModel: AuthViewModelProtocol {
    var session: pack.User?
    var error: pack.AuthError?
    var isAuthenticated: Bool = false
    var messageError: String = ""
    var onLoginSucceed: (() -> Void)?
    var saveEmail: String?
    var savePassword: String?



    // Désactiver la connexion automatique
    func disableAutoLogin() async throws {
        if isAuthenticated {
            messageError = "Erreur de déconnexion"
            throw ShowErrors.disableAutoLoginThrowError
        }
    }
//
//    // Sauvegarder l'état de connexion automatique
//    func saveAutoConnectionState(_ state: Bool) {
//        if state {
//            UserDefaults.standard.set(state, forKey: "autoConnection")
//        }
//    }

//    // Connexion automatique avec email et mot de passe sauvegardés
//    func autotoLogin() async throws {
//        guard let email = UserDefaults.standard.string(forKey: "email"),
//              let password = UserDefaults.standard.string(forKey: "password") else {
//            messageError = "Veuillez remplir tous les champs"
//            return
//        }
//        
//        guard !email.isEmpty, !password.isEmpty else {
//            messageError = "Veuillez remplir tous les champs"
//            saveEmail = ""
//            savePassword = ""
//            return
//        }
//        
//        saveEmail = email
//        savePassword = password
//        messageError = ""
//        
//        do {
//            try await login(email: email, password: password)
//        } catch {
//            messageError = "Erreur lors de la connexion (sauvegarde échouée)"
//        }
//    }

    // Implémentation de la méthode pour signUp
    func signUp(email: String, password: String) async throws -> pack.User {
        if email == "joe@gmail.com" && password == "123456" {
            let user = pack.User(uid: "12345", email: email)
            self.session = user
            return user
        } else {
            throw ShowErrors.createdNewUserThrowError
        }
    }

    // Implémentation de la méthode pour signIn
    func signIn(email: String, password: String) async throws -> pack.User {
        if email == "joe@gmail.com" && password == "123456" {
            let user = pack.User(uid: "12345", email: email)
            self.session = user
            return user
        } else {
            throw ShowErrors.loginThrowError
        }
    }


    // Simuler la méthode listen() (aucune action ici, juste pour faire passer les tests)
    func listen() async throws {
        // Aucune action spécifique ici
    }
}
