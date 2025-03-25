//
//  AuthViewModelProtocol.swift
//  pack
//
//  Created by Modibo on 21/03/2025.
//

import Foundation

protocol AuthViewModelProtocol {
        var session: User? { get set }
        var error: AuthError? { get set }
        var isAuthenticated: Bool { get }
        
        func disableAutoLogin() async throws
        func listen() async throws
        func signUp(email: String, password: String) async throws -> User
        func signIn(email: String, password: String) async throws -> User
        func signOut() async throws
        func stopListeningToAuthChanges()
}


