////
////  ManagementAuthViewModel.swift
////  pack
////
////  Created by Modibo on 21/03/2025.
////
//
//import Foundation
//
//class ManagementAuthViewModel: AuthViewModelProtocol, ObservableObject {
//    @Published var _isAuthenticated : Bool = false
//    @Published var _messageError : String = ""
//    @Published var onLoginSucceed: (() -> Void)?
//    private var session: SessionStore
// 
//    var isAuthenticated : Bool {_isAuthenticated}
//    var messageError : String {_messageError}
//    init(session: SessionStore = SessionStore()) {
//        self.session = session
//        session.$session
//            .map { $0 != nil }
//            .assign(to: &$_isAuthenticated)
//
//    }
//    
//    @MainActor
//    func login(email: String, password: String) async throws {
//        do {
//            let user = try await session.signIn(email: email, password: password)
//            UserDefaults.standard.set(user.email, forKey: "email")
//            onLoginSucceed?()
//        } catch {
//            _messageError = "Erreur lors de la connexion de l'utilisateur"
//            throw ShowErrors.loginThrowError
//        }
//    }
//    
//    @MainActor
//    func createdNewUser(email: String, password: String) async throws {
//        do {
//           let user = try await session.signUp(email: email, password: password)
//            UserDefaults.standard.set(user.email, forKey: "email")
//            _messageError = ""
//        } catch {
//            _messageError = "Erreur lors de la création de l'utilisateur"
//            throw ShowErrors.createdNewUserThrowError
//        }
//    }
//    
//    func changeStatus() async throws {
//        do {
//           try await session.listen()
//        } catch {
//            throw ShowErrors.changeStatusThrowError
//        }
//    }
//    
//    func disableAutoLogin() async throws {
//        do {
//            try await session.disableAutoLogin()
//        } catch {
//            throw ShowErrors.disableAutoLoginThrowError
//        }
//    }
//    
//    func saveAutoConnectionState(_ state: Bool) {
//        UserDefaults.standard.set(state, forKey: "autoLogin")
//    }
//    
//    @MainActor
//    func autotoLogin() async throws {
//        if let savedEmail = UserDefaults.standard.string(forKey: "email"),
//           let savedPassword = UserDefaults.standard.string(forKey: "password") {
//            try await login(email: savedEmail, password: savedPassword)
//        }
//    }
//}
