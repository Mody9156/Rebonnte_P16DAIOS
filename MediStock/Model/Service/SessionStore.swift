import Foundation
import Firebase
import FirebaseAuth

class SessionStore: ObservableObject {
    @Published var session: User?
    @Published var messageError = ""
    var handle: AuthStateDidChangeListenerHandle?

    func listen() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, email: user.email)
                self.messageError = ""
            } else {
                self.session = nil
                self.messageError = "Session invalid"
            }
        }
    }

    func signUp(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.messageError = "Error creating user: \(error.localizedDescription) \(error)"
                print("Error creating user: \(error.localizedDescription) \(error)")
            } else {
                self.session = User(uid: result?.user.uid ?? "", email: result?.user.email ?? "")
                self.messageError = ""
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.messageError = "Error signing in: \(error.localizedDescription)"
                print("Error signing in: \(error.localizedDescription)")
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
