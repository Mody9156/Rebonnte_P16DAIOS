//
//  FirebaseAuthService.swift
//  pack
//
//  Created by KEITA on 24/01/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class FirebaseAuthService: AuthServiceProtocol {
    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return  User(uid: result.user.uid, email: result.user.email)
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return User(uid: result.user.uid, email: result.user.email)
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    func addDidChangeListenerHandle(listener: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                listener(User(uid: user.uid,email: user.email))
            }else{
                listener(nil)
            }
        }
    }
    
    func removeDidChangeListenerHandle(handle: AuthStateDidChangeListenerHandle) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
