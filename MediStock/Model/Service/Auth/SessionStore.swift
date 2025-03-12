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
        }catch {
            throw AuthError.disableAutoLogin
        }
    }
    
    func listen()  {
        authService.addDidChangeListenerHandle { [weak self] user in
            self?.session = user
            if user == nil {
                self?.error = .userIsEmpty
            }
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
            throw AuthError.signInThrowError
        }
    }
    
    func signOut() async throws  {
        
        do {
            try await authService.signOut()
            self.session = nil
        } catch {
            throw AuthError.signOutThrowError
        }
        
    }
    
    func stopListeningToAuthChanges() {
        if let handle = handle {
            authService.removeDidChangeListenerHandle(handle: handle)
            self.handle = nil
        }
    }
}

enum AuthError: Error {
    case invalidCredentials
    case userCreationFailed
    case userIsEmpty
    case disableAutoLogin
    case signInThrowError
    case signOutThrowError
}
