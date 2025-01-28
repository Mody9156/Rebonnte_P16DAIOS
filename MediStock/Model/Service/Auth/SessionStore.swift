import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

public class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var error: AuthError?
    
    private var handle: AuthStateDidChangeListenerHandle?
    private var authService : AuthServiceProtocol
    var isAuthenticated : Bool {
        session != nil
    }
    
    init(authService: AuthServiceProtocol = FirebaseAuthService(),session: User? = nil, handle: AuthStateDidChangeListenerHandle? = nil) {
        self.authService = authService
        self.session = session
        self.handle = handle
    }
    
    func disableAutoLogin() async throws {
        if session != nil {
            try await authService.signOut()
            print("Déconnexion réussie pour désactiver la persistance.")
        }
    }
        
    func listen() {
        try await authService.signOut()
        authService.addDidChangeListenerHandle { [weak self] user in
            DispatchQueue.main.async {
                self?.session = user
                self?.error = user == nil ? .unknown : nil
            }
        }
    }
    
    func signUp(email: String, password: String) async throws -> User  {
        do{
            let user = try await authService.signUp(email: email, password: password)
            DispatchQueue.main.async {
                self.session = user
            }
            return user
        }catch{
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws -> User{
        do{
            let user = try await authService.signIn(email: email, password: password)
            DispatchQueue.main.async {
                self.session = user
            }
            return user
        }catch{
            throw error
        }
    }
    
    func signOut() async throws  {
        guard session != nil else {
            print("Aucune session active.")
            return
        }
        
            do {
                    try await authService.signOut()
                    DispatchQueue.main.async {
                        self.session = nil
                    }
                print("Déconnexion réussie pour désactiver la persistance.")
            } catch {
                print("Erreur lors de la déconnexion : \(error.localizedDescription)")
                throw error
            }
        
    }
    
    func stopListeningToAuthChanges() {
        if let handle = handle {
            authService.removeDidChangeListenerHandle(handle: handle)
            self.handle = nil
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
