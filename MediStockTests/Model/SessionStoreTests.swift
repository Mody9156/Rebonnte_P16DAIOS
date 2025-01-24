//
//  SessionStoreTests.swift
//  MediStockTests
//
//  Created by KEITA on 24/01/2025.
//

import XCTest
@testable import pack 

class SessionStoreTests: XCTestCase {
    var sessionStore: SessionStore!
    var mockAuthService: MockAuthService!

    override func setUp() {
        mockAuthService = MockAuthService()
        sessionStore = SessionStore(authService: mockAuthService)
    }

    func testSignInSuccess() async throws {
        mockAuthService.mockUser = User(uid: "mockUID", email: "test@example.com")
        let user = try await sessionStore.signIn(email: "test@example.com", password: "password")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertNotNil(sessionStore.session)
    }

    func testSignInFailure() async {
        mockAuthService.shouldThrowError = true
        do {
            _ = try await sessionStore.signIn(email: "test@example.com", password: "password")
            XCTFail("Expected an error but did not get one")
        } catch {
            XCTAssertEqual(error as? AuthError, AuthError.invalidCredentials)
        }
    }
}

