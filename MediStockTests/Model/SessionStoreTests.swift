//
//  SessionStoreTests.swift
//  MediStockTests
//
//  Created by KEITA on 24/01/2025.
//

import XCTest
@testable import pack
import FirebaseAuth
import FirebaseFirestore

class SessionStoreTests: XCTestCase {
    var sessionStore: SessionStore!
    var mockAuthService: MockAuthService!

    override func setUp() {
        mockAuthService = MockAuthService()
        sessionStore = SessionStore(authService: mockAuthService, session: User(uid: "mockTest",email: "Fake@gmail.com"))
    }

    
    func delete(){
        var user = mockAuthService.mockUser
        user?.uid.removeAll()
        user?.email?.removeAll()
    }
    
    
    func testSignInSuccess() async throws {
        mockAuthService.shouldThrowError = false
        _ = try await sessionStore.signUp(email: "test@example.com", password: "password")
        let user = try await sessionStore.signIn(email: "test@example.com", password: "password")
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertNotNil(sessionStore.session)
        print("session \(String(describing: sessionStore.session))")
        XCTAssertNoThrow(user)
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
    
    func testSignUpSuccess() async throws {
        let user = try await sessionStore.signUp(email: "test2@example.com", password: "password")
        XCTAssertTrue(((user.email?.isEmpty) != nil))
        XCTAssertFalse(user.uid.isEmpty)
        XCTAssertNoThrow(user)
    }
    
    func testSignUpFailure() async throws {
        mockAuthService.shouldThrowError = true
        do{
            _ = try await sessionStore.signUp(email: "test@example.com", password: "password")
            XCTFail("Expected an error but did not get one")
        }catch{
            XCTAssertEqual(error as? AuthError, AuthError.userCreationFailed)
        }
    }
   
}

