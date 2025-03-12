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
import Testing

class SessionStoreTests: XCTestCase {
    var sessionStore: SessionStore!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        mockAuthService = MockAuthService()
        sessionStore = SessionStore(authService: mockAuthService, session: User(uid: "mockTest",email: "Fake@gmail.com"),handle: mockAuthService.mockHandle)
    }
    
    
    func testSignInSuccess() async throws {
        //give
        mockAuthService.shouldThrowError = false
        //When
        _ = try await sessionStore.signUp(email: "test@example.com", password: "password")
        let user = try await sessionStore.signIn(email: "test@example.com", password: "password")
        //Then
        XCTAssertEqual(user.email, "test@example.com")
        XCTAssertEqual(user.uid, "mockUID")
        XCTAssertNotNil(sessionStore.session)
        print("session \(String(describing: sessionStore.session))")
        XCTAssertNoThrow(user)
    }
    
    func testSignInFailure() async {
        //give
        mockAuthService.shouldThrowError = true
        do {
            //When
            _ = try await sessionStore.signIn(email: "test@example.com", password: "password")
            //Then
            XCTFail("Expected an error but did not get one")
        } catch {
            //Then
            XCTAssertEqual(error as? AuthError, AuthError.signInThrowError)
        }
    }
    
    func testSignUpSuccess() async throws {
        //When
        let user = try await sessionStore.signUp(email: "test2@example.com", password: "password")
        //Then
        XCTAssertTrue(((user.email?.isEmpty) != nil))
        XCTAssertFalse(user.uid.isEmpty)
        XCTAssertNoThrow(user)
        XCTAssertNotNil(sessionStore.session)
        XCTAssertEqual(user.uid, "mockUID")
    }
    
    func testSignUpFailure() async throws {
        //give
        mockAuthService.shouldThrowError = true
        do{
            //When
            _ = try await sessionStore.signUp(email: "test@example.com", password: "password")
            //Then
            XCTFail("Expected an error but did not get one")
        }catch{
            //Then
            XCTAssertEqual(error as? AuthError, AuthError.userCreationFailed)
        }
    }
    
    
    func testWhenSignOutSuccess() async throws {
        //When
        _ = try await sessionStore.signOut()
        //Then
        XCTAssertFalse(mockAuthService.shouldThrowError)
    }
    
    func testWhenSignOutThrowError() async throws {
        //Given
        mockAuthService.shouldThrowError = true
        //When
        do{
            _ = try await sessionStore.signOut()
            //Then
            XCTFail("Expected an error but did not get one")
        }catch {
            //Then
            XCTAssertEqual(error as? AuthError, AuthError.signOutThrowError)
        }
    }
    
    func testWhenListeningToAuthChangesSuccess() {
        // Given 
        let user = User(uid: "fakeUIid", email: "exemple@gmail.com")
        mockAuthService.mockUser = user

        // When
        sessionStore.listen()

        // Then
        XCTAssertNotNil(sessionStore.session)
        XCTAssertNil(sessionStore.error)
    }
   
    func testWhenListeninToAuthChangesFail() async throws {
        //When
        mockAuthService.mockUser = nil
        //When
        mockAuthService.addDidChangeListenerHandle { user in
            //Then
            XCTAssertNil(user)
        }
        //When
        sessionStore.listen()
        //Then
        XCTAssertNotNil(sessionStore.error)
    }
    
    func testDisableNoThrowsErrors() async throws {
        //Given
        let email = "fakeEmail@gmail.com"
        let password = "123456"
        mockAuthService.shouldThrowError = false
        
        //When
        let _ = try await mockAuthService.signUp(email: email, password: password)
        let _ = try await mockAuthService.signIn(email: email, password: password)
        let disable : () = try await mockAuthService.disableAutoLogin()
        //Then
        XCTAssertNoThrow(disable)
    }
    
    func testWhenDisableThrowsError() async throws {
        //Given
        let email = "fake2Email@gmail.com"
        let password = "123456d"
        mockAuthService.shouldThrowError = true
        
        //When
        do{
            try await sessionStore.disableAutoLogin()
        }catch let error as AuthError{
            XCTAssert(error == .disableAutoLogin)
        }

    }
    
    func testRemoveDidChangeListenerHandle() async throws {
        mockAuthService.didAddListener = true
        // When (Appel de la fonction)
        let fakeHandle: AuthStateDidChangeListenerHandle = NSObject() // Simule un handle quelconque
        mockAuthService.removeDidChangeListenerHandle(handle: fakeHandle)

        mockAuthService.removeDidChangeListenerHandle(handle: fakeHandle)
    }
}

