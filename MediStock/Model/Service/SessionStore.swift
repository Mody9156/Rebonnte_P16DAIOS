import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var error: AuthError?
    
    private var handle: AuthStateDidChangeListenerHandle?
    private var authService : AuthServiceProtocol
    var isAuthenticated : Bool {
        session != nil
    }
    
    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
    }
    
    func disableAutoLogin() async throws {
        if session != nil {
            try await authService.signOut()
            print("Déconnexion réussie pour désactiver la persistance.")
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
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            self.handleAuthResult(result, error, completion: completion)
//
//        }
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
    
    @MainActor
    func signOut() async throws  {
        do {
            try Auth.auth().signOut()
                self.session = nil
        } catch {
            DispatchQueue.main.async {
                self.error = .unknown
            }
        }
    }
    
    func stopListeningToAuthChanges() {
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
