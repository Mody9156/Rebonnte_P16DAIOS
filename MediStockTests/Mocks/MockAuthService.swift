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


class MockAuthService: AuthServiceProtocol {
  
    var mockUser: pack.User?
    var shouldThrowError: Bool = false
    var didAddListener : Bool = false
    var mockHandle: AuthStateDidChangeListenerHandle? = NSObject() // Handle factice

    func signUp(email: String, password: String) async throws -> pack.User {
        if shouldThrowError { throw AuthError.userCreationFailed }
        return User(uid: "mockUID", email: email)
    }

    func signIn(email: String, password: String) async throws -> pack.User {
        if shouldThrowError { throw AuthError.signInThrowError }
        return User(uid: "mockUID", email: email)
    }

    func signOut() async throws {
        if shouldThrowError { throw AuthError.signOutThrowError }
    }

    func addDidChangeListenerHandle(listener: @escaping (pack.User?) -> Void) {
        listener(mockUser)
    }
    
    func removeDidChangeListenerHandle(handle: AuthStateDidChangeListenerHandle) {
        
        didAddListener = true
    }
    
    func disableAutoLogin() async throws {
        if shouldThrowError {throw AuthError.disableAutoLogin}
    }
}
