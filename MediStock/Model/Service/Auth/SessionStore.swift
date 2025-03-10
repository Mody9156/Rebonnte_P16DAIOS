import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

public class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var error: AuthError?
    
    var handle: AuthStateDidChangeListenerHandle?
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
        do{
            try await authService.disableAutoLogin()
            print("Déconnexion réussie pour désactiver la persistance.")
        }catch {
            throw AuthError.disableAutoLogin
        }
    }
    
    func listen()  {
        authService.addDidChangeListenerHandle { [weak self] user in
            self?.session = user
            self?.error = user == nil ? .unknown : nil
        }
    }
      
    
    func signUp(email: String, password: String) async throws -> User  {
        do{
            let user = try await authService.signUp(email: email, password: password)
            self.session = user
            return user
        }catch{
            throw AuthError.userCreationFailed
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws -> User{
        do{
            let user = try await authService.signIn(email: email, password: password)
                self.session = user
            return user
        }catch{
            throw error
        }
    }
    
    func signOut() async throws  {
        
        do {
            try await authService.signOut()
            self.session = nil
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
    case disableAutoLogin
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Impossible de se connecter. Vérifiez vos informations et réessayez."
        case .userCreationFailed:
            return "Impossible de créer un compte. Vérifiez vos informations et réessayez."
        case .unknown:
            return "Une erreur inconnue est survenue."
        case .disableAutoLogin:
            return "Impossible de reintitialisé l'authentification automatique. Veuillez vous déconnecter et réessayer."
        }
    }
}
