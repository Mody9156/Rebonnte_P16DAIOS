//
//  ManagementAuthViewModel.swift
//  pack
//
//  Created by Modibo on 21/03/2025.
//

import Foundation

class ManagementAuthViewModel: AuthViewModelProtocol {
    
    var isAuthenticated: Bool = false
    var messageError: String = ""
    var onLoginSucceed: (() -> Void)?
    
    private var session: SessionStore
    
    init(session: SessionStore = SessionStore()) {
        self.session = session
    }
    
    @MainActor
    func login(email: String, password: String) async throws {
        do {
            let user = try await session.signIn(email: email, password: password)
            UserDefaults.standard.set(user.email, forKey: "email")
            messageError = ""
            isAuthenticated = true
            onLoginSucceed?()
        } catch {
            messageError = "Erreur lors de la connexion de l'utilisateur"
            isAuthenticated = false
            throw ShowErrors.loginThrowError
        }
    }
    
    @MainActor
    func createdNewUser(email: String, password: String) async throws {
        do {
           let _ = try await session.signUp(email: email, password: password)
            messageError = ""
        } catch {
            messageError = "Erreur lors de la création de l'utilisateur"
            throw ShowErrors.createdNewUserThrowError
        }
    }
    
    @MainActor
    func changeStatus() async throws {
        do {
            try await session.listen()
        } catch {
            throw ShowErrors.changeStatusThrowError
        }
    }
    
    func disableAutoLogin() async throws {
        do {
            try await session.disableAutoLogin()
        } catch {
            throw ShowErrors.disableAutoLoginThrowError
        }
    }
    
    func saveAutoConnectionState(_ state: Bool) {
        UserDefaults.standard.set(state, forKey: "autoLogin")
    }
    
    @MainActor
    func autotoLogin() async throws {
        if let savedEmail = UserDefaults.standard.string(forKey: "email"),
           let savedPassword = UserDefaults.standard.string(forKey: "password") {
            try await login(email: savedEmail, password: savedPassword)
        }
    }
}
