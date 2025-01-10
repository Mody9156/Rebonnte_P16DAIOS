import Foundation
import Firebase
import FirebaseAuth

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var messageError = ""
    var handle: AuthStateDidChangeListenerHandle?

    func listen(completion:@escaping(User?) -> Void) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
                self.messageError = ""
                print("\(String(describing: self.session))")
                completion(self.session)
            } else {
                self.session = nil
                self.messageError = "Session invalid"
            }
        }
    }

    func signUp(email: String, password: String, completion: @escaping(Result<User,Error>) -> Void)  {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.messageError = "Error creating user: \(error.localizedDescription) \(error)"
                print("\(String(describing: self.session))")
                print("Error creating user: \(error.localizedDescription) \(error)")
                completion(.failure(error))
            } else if let user = result?.user {
                let customUser = User(uid: user.uid , email: user.email)
                self.session = customUser
                self.messageError = ""
                completion(.success(customUser))
            }else {
                let unknownError = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred during sign-up"])
                completion(.failure(unknownError))
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.messageError = "Error signing in: \(error.localizedDescription)"
                print("Error signing in: \(error.localizedDescription)")
                print("\(String(describing: self.session))")
            } else {
                self.session = User(uid: result?.user.uid ?? "", email: result?.user.email ?? "")
                self.messageError = ""
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch let error {
            self.messageError = "Error signing out: \(error.localizedDescription)"
        }
    }

    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
