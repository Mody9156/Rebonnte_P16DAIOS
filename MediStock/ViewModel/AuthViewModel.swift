
import Foundation

enum ShowErrors : Error {
    case disableAutoLoginThrowError
    case changeStatusThrowError
    case loginThrowError
    case createdNewUserThrowError
}

class AuthViewModel : ObservableObject {
    @Published var session: AuthViewModelProtocol
    @Published var messageError : String = ""
    @Published var onLoginSucceed : (()-> Void)?
    @Published var isAuthenticated : Bool = false
    
    init(session : AuthViewModelProtocol = SessionStore(),onLoginSucceed : (()-> Void)? = nil ){
        self.session = session
        self.onLoginSucceed = onLoginSucceed
        if let sessionStore = session as? SessionStore {
            sessionStore.$session
                .map { $0 != nil }
                .assign(to: &$isAuthenticated)
        }
        
    }
    
    @MainActor
    func login(email:String, password:String) async throws {
        do {
            
            let user = try await session.signIn(email: email, password: password)
            UserDefaults.standard.set(user.email, forKey: "email")
            messageError = ""
            isAuthenticated = true
            onLoginSucceed?()
        }catch{
            messageError = "Erreur lors de la connexion de l'utilisateur"
            isAuthenticated = false
            throw ShowErrors.loginThrowError
        }
    }
    
    @MainActor
    func createdNewUser(email: String, password: String) async throws {
        do{
            let user = try await session.signUp(email: email, password: password)
            UserDefaults.standard.set(user.email, forKey: "email")
            messageError = ""
        }catch{
            messageError = "Erreur lors de la création de l'utilisateur"
            throw ShowErrors.createdNewUserThrowError
        }
    }
    
    @MainActor
    func changeStatus() async throws {
        do{
            try await session.listen()
        }catch{
            throw ShowErrors.changeStatusThrowError
        }
    }
    
    func disableAutoLogin() async throws {
        do{
            try await session.disableAutoLogin()
        }catch{
            throw ShowErrors.disableAutoLoginThrowError
        }
    }
    
    func saveAutoConnectionState(_ state:Bool) async throws {
        if state {
            UserDefaults.standard.set(state, forKey: "autoLogin")
        }else {
            throw ShowErrors.loginThrowError
        }
    }
    
    func autotoLogin() async throws {
        guard let saveEmail = UserDefaults.standard.string(forKey: "email"),
                 let savePassword = UserDefaults.standard.string(forKey: "password") else {
               throw ShowErrors.loginThrowError 
           }

           let _ = try await session.signIn(email: saveEmail, password: savePassword)
           
    }
}
