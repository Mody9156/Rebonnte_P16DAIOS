//
//  AuthServiceProtocol.swift
//  pack
//
//  Created by KEITA on 24/01/2025.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

protocol AuthServiceProtocol {
    func signUp(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    func addDidChangeListenerHandle(listener: @escaping (User?) -> Void)
    func removeDidChangeListenerHandle(handle : AuthStateDidChangeListenerHandle)
}
