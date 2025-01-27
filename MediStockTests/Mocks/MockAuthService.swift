//
//  MockAuthService.swift
//  MediStockTests
//
//  Created by KEITA on 24/01/2025.
//

import XCTest
@testable import pack
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class MockAuthService: AuthServiceProtocol {
    var mockUser: User?
    var shouldThrowError: Bool = false
    var didAddListener : Bool = false
    var mockHandle: AuthStateDidChangeListenerHandle = NSObject() // Handle factice

    func signUp(email: String, password: String) async throws -> User {
        if shouldThrowError { throw AuthError.userCreationFailed }
        return mockUser
    }

    func signIn(email: String, password: String) async throws -> User {
        if shouldThrowError { throw AuthError.invalidCredentials }
        return mockUser
    }

    func signOut() async throws {
        if shouldThrowError { throw AuthError.unknown }
    }

    func addDidChangeListenerHandle(listener: @escaping (pack.User?) -> Void) {
        listener(mockUser)
    }
    
    func removeDidChangeListenerHandle(handle: AuthStateDidChangeListenerHandle) {
        didAddListener = true
    }
}

