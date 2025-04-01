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
        sessionStore = SessionStore(authService: mockAuthService, session: User(uid: "mockTest",email: "Fake@gmail.com"),handle: mockAuthService.mockHandle)
    }
    
    
    func testSignInSuccess() async throws {
        //given
          mockAuthService.shouldThrowError = false
          //When
          let user = try await sessionStore.signIn(email: "test@example.com", password: "password")
          
          //Then
          XCTAssertEqual(user.email, "test@example.com")
          XCTAssertEqual(user.uid, "mockUID")
          XCTAssertNotNil(sessionStore.session)
          print("session \(String(describing: sessionStore.session))")
          

    }
    
    func testSignInFailure() async {
        // Given
          mockAuthService.shouldThrowError = true
          
          // When
          do {
              // Tentative de connexion avec des informations incorrectes
             let _ = try await sessionStore.signIn(email: "test@example.com", password: "password")
              
              // Si on arrive ici, c'est qu'il n'y a pas eu d'erreur, donc le test échoue
              XCTFail("Expected an error but did not get one")
          } catch let error as AuthError {
              // Vérifier que l'erreur est bien celle attendue
              XCTAssertEqual(error, AuthError.signInThrowError)
          } catch {
              // C'est un bloc catch générique qui attrape d'autres erreurs non spécifiées
              XCTFail("Unexpected error occurred: \(error)")
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
        //given
           mockAuthService.shouldThrowError = true
           do {
               // Tentative d'inscription
               _ = try await sessionStore.signUp(email: "test@example.com", password: "password")
               // Si on arrive ici, le test échoue
               XCTFail("Expected an error but did not get one")
           } catch let error as AuthError {
               // Vérification que l'erreur levée est celle attendue
               XCTAssertEqual(error, AuthError.userCreationFailed)
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
    
    func testWhenListeningToAuthChangesSuccess() async throws {
        // Given
        let user = User(uid: "fakeUIid", email: "exemple@gmail.com")
        mockAuthService.mockUser = user
        
        // When
        try? await sessionStore.listen()
        
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
        try? await sessionStore.listen()
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
        mockAuthService.shouldThrowError = true
        //When
        do{
            try await sessionStore.disableAutoLogin()
        }catch let error as AuthError{
            XCTAssert(error == .disableAutoLogin)
        }
        
    }
    
    func testRemoveDidChangeListenerHandle() async throws {
        //Given
        let fakeHandle: AuthStateDidChangeListenerHandle = NSObject() // Simule un handle quelconque
        sessionStore.handle = fakeHandle
        //When
        sessionStore.stopListeningToAuthChanges()
        //Then
        XCTAssertNil(sessionStore.handle)
    }
    
    func testRemoveDidChangeListenerHandleThrowsErrorWhenHandleNotFound() async throws {
        //Given
        sessionStore.handle = nil
        //When
        sessionStore.stopListeningToAuthChanges()
        //Then
        XCTAssertNil(sessionStore.handle)
    }
    
    func testStopListeningToAuthChanges_CallsRemoveDidChangeListenerHandle() {
        //Given
        let fakeHandle: AuthStateDidChangeListenerHandle = NSObject() // Simule un handle quelconque
        sessionStore.handle = fakeHandle
        //When
        sessionStore.stopListeningToAuthChanges()
        //Then
        XCTAssertTrue(mockAuthService.didAddListener)
    }
}

