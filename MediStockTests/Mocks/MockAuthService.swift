//
//  MockAuthService.swift
//  MediStockTests
//
//  Created by KEITA on 24/01/2025.
//

import XCTest
@testable import pack
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class MockAuthService: AuthServiceProtocol {
    var mockUser: User?
    var shouldThrowError: Bool = false

    func signUp(email: String, password: String) async throws -> User {
        if shouldThrowError { throw AuthError.userCreationFailed }
        return User(uid: "mockUID", email: email)
    }

    func signIn(email: String, password: String) async throws -> User {
        if shouldThrowError { throw AuthError.invalidCredentials }
        return User(uid: "mockUID", email: email)
    }

    func signOut() async throws {
        if shouldThrowError { throw AuthError.unknown }
    }

    func addDidChangeListenerHandle(listener: @escaping (pack.User?) -> Void) {
        listener(mockUser)
    }
    
    func removeDidChangeListenerHandle(handle: AuthStateDidChangeListenerHandle) {
        Auth.auth().removeStateDidChangeListener(handle)
    }
}

