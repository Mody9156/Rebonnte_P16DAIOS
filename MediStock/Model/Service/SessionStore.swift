import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var error: AuthError?
    
    var handle: AuthStateDidChangeListenerHandle?
    var isAuthenticated : Bool {
        session != nil
    }
    
    func disableAutoLogin() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                print("Déconnexion réussie pour désactiver la persistance.")
            } catch let error {
                print("Erreur lors de la déconnexion : \(error.localizedDescription)")
            }
        }
    }
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            DispatchQueue.main.async {
                if let user = user {
                    self?.session = User(uid: user.uid, email: user.email)
                    self?.error = nil
                } else {
                    self?.session = nil
                    self?.error = .unknown
                }
            }
        }
    }
    
    
    
    func signUp(email: String, password: String, completion: @escaping(Result<User,Error>) -> Void)  {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            self.handleAuthResult(result, error, completion: completion)
            
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping(Result<User,Error>) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion(.failure(AuthError.invalidCredentials))
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            self.handleAuthResult(result, error, completion: completion)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.clearUserData()
            self.session = nil
        } catch {
            DispatchQueue.main.async {
                self.error = .unknown
            }
        }
    }
    
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
            self.handle = nil
        }
    }
    
    private func handleAuthResult(_ result: AuthDataResult?, _ error: Error?, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(error))
            } else if let user = result?.user {
                let customUser = User(uid: user.uid, email: user.email)
                completion(.success(customUser))
            } else {
                completion(.failure(AuthError.unknown))
            }
        }
    }
    
    private func saveUserData(_ user: User) {
        // Sauvegarder les informations de l'utilisateur dans UserDefaults
        UserDefaults.standard.set(user.uid, forKey: "userUid")
        UserDefaults.standard.set(user.email, forKey: "userEmail")
        
    }
    
    private func clearUserData() {
        // Réinitialiser les données utilisateur précédentes dans UserDefaults
        UserDefaults.standard.removeObject(forKey: "userUid")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials
    case userCreationFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Impossible de se connecter. Vérifiez vos informations et réessayez."
        case .userCreationFailed:
            return "Impossible de créer un compte. Vérifiez vos informations et réessayez."
        case .unknown:
            return "Une erreur inconnue est survenue."
        }
    }
}
