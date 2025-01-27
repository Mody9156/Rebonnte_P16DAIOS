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
import FirebaseCore
import FirebaseAuth

protocol UserProtocol {
    
}

class MockUser : Users {
    private let emailValue: String?

     override var email: String? {
         return emailValue
     }

     init(email: String?) {
         self.emailValue = email
         super.init() // Firebase User ne fournit pas de constructeur public, ceci est fictif
     }
}


class MockAuthService: AuthServiceProtocol {
    var mockUser: User?
    var shouldThrowError: Bool = false
    var didAddListener : Bool = false
    var mockHandle: AuthStateDidChangeListenerHandle = NSObject() // Handle factice

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
        didAddListener = true
    }
}

