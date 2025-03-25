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
    
    func disableAutoLogin() async throws {
        if isAuthenticated {
            messageError = "Erreur de déconnexion"
            throw ShowErrors.disableAutoLoginThrowError
        }else{
            messageError = ""
        }
    }
    
    func signUp(email: String, password: String) async throws -> pack.User {
        guard email != "joe@gmail.com" else {
            throw ShowErrors.createdNewUserThrowError
        }
        
        if email == "joe_3@gmail.com" && password == "123456" {
            isAuthenticated = true
            saveEmail = email
            savePassword = password
            messageError = ""
            return pack.User.testUser_3
        } else {
            messageError = "Erreur lors de la création de l'utilisateur"
            isAuthenticated = false
            throw ShowErrors.createdNewUserThrowError
        }
    }
    
    func signIn(email: String, password: String) async throws -> pack.User {
        
        if email == "joe@gmail.com" && password == "123456"{
            isAuthenticated = true
            saveEmail = email
            savePassword = password
            return pack.User.testUser_2
        } else {
            isAuthenticated = false
            throw ShowErrors.loginThrowError
        }
    }
    
    func listen() async throws {
        if isAuthenticated {
            messageError = "erreur de deconnexion"
            throw ShowErrors.disableAutoLoginThrowError
        }else {
            messageError = ""
        }
    }
}
