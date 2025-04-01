//
//  AuthViewModelTestss.swift
//  MediStockTests
//
//  Created by Modibo on 26/03/2025.
//
import XCTest
@testable import pack
import Foundation

class AuthViewModelTestss: XCTestCase {
    
    func testLoginWithRightValues() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        
        // When
        do {
            try await authViewModel.login(email: "joe@gmail.com", password: "123456")
            
            // Then
            XCTAssertTrue(authViewModel.messageError.isEmpty)
            XCTAssertEqual(mockAuthService.saveEmail, "joe@gmail.com")
            XCTAssertEqual(mockAuthService.savePassword, "123456")
            XCTAssertTrue(mockAuthService.isAuthenticated)
        } catch {
            XCTFail("Expected no error, but got \(error)")
        }
    }
    
    func testEmailOrPasswordIsInvalid() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        
        // When/Then
        do {
            try await authViewModel.login(email: "", password: "")
            XCTFail("Expected error, but no error was thrown")
        } catch let error as ShowErrors {
            XCTAssertEqual(error, ShowErrors.loginThrowError)
            XCTAssertFalse(mockAuthService.isAuthenticated)
            XCTAssertNil(mockAuthService.saveEmail)
            XCTAssertNil(mockAuthService.savePassword)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testCreatedNewUserDoesNotThrowError() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        
        // When
        do {
            try await authViewModel.createdNewUser(email: "joe_3@gmail.com", password: "123456")
            
            // Then
            XCTAssertTrue(mockAuthService.messageError.isEmpty)
            XCTAssertTrue(mockAuthService.isAuthenticated)
            XCTAssertEqual(mockAuthService.saveEmail, "joe_3@gmail.com")
            XCTAssertEqual(mockAuthService.savePassword, "123456")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testCreatedNewUserWithSameEmailThrowError() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        mockAuthService.isAuthenticated = true
        // When/Then
        do {
            try await authViewModel.createdNewUser(email: "joe@gmail.com", password: "123456")
            XCTFail("Expected error, but no error was thrown")
        } catch let error as ShowErrors {
            XCTAssertEqual(error, ShowErrors.createdNewUserThrowError)
            XCTAssertTrue(mockAuthService.isAuthenticated)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testDisableNoThrowError() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        
        // When
        do {
            try await authViewModel.disableAutoLogin()
            
            // Then
            XCTAssertEqual(mockAuthService.messageError, "")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    func testDisableThrowError() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        mockAuthService.isAuthenticated = true
        
        // When
        do {
            // This will throw the error we expect when the service fails to log out
            try await authViewModel.disableAutoLogin()
            
            // If no error is thrown, the test will fail
            XCTFail("Expected error, but no error was thrown.")
        } catch let error as ShowErrors {
            // Then
            // Ensure that the error matches what we expect
            XCTAssertEqual(error, ShowErrors.disableAutoLoginThrowError)
            XCTAssertEqual(mockAuthService.messageError, "Erreur de déconnexion")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    
    func testWhenChangeStatusIsAuthenticatedThenCallOnChangeStatusAuthenticated() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)

        // When
        do {
            // Call the changeStatus method
            try await authViewModel.changeStatus()

            // Then: Ensure no error is thrown, and check the result
            XCTAssertEqual(mockAuthService.messageError, "")

            // If the async call doesn't throw an error, the assertions below will be checked
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testWhenChangeStatusIsAuthenticatedThenCallOnChangeStatusAuthenticatedThrowError() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        mockAuthService.isAuthenticated = true

        // When
        do {
            // First call to changeStatus() should throw an error
            try await authViewModel.changeStatus()

            // If no error is thrown, the test should fail
            XCTFail("Expected error, but no error was thrown.")
        } catch let error as ShowErrors {
            // Then: Check if the expected error is thrown
            XCTAssertEqual(error, ShowErrors.changeStatusThrowError)
            XCTAssertEqual(mockAuthService.messageError, "erreur de deconnexion")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    
    func testWhenYouWantSaveUserWithClickOnButton() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        
        // When/Then
        do {
            try await authViewModel.saveAutoConnectionState(true)
            let userDefault = UserDefaults.standard.bool(forKey: "autoLogin")
            XCTAssertTrue(userDefault)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testWhenYouWantSaveUserWithNotClickOnButton() async {
        // Given
           let mockAuthService = MockAuthViewModel()
           let authViewModel = AuthViewModel(session: mockAuthService)

           // Clear UserDefaults before the test to prevent residual values
           UserDefaults.standard.removeObject(forKey: "autoLogin")

           do {
               // Try saving with 'false' state, which should throw an error
               try await authViewModel.saveAutoConnectionState(false)
               
               // If we get here, the test has failed because we expected an error
               XCTFail("Expected error but no error was thrown.")
           } catch let error as ShowErrors {
               // Then: Check that the expected error is thrown
               XCTAssertEqual(error, ShowErrors.loginThrowError)
           } catch {
               XCTFail("Unexpected error: \(error)")
           }

           // After the error is thrown, check that the 'autoLogin' state was not saved
           let userDefault = UserDefaults.standard.bool(forKey: "autoLogin")
           XCTAssertFalse(userDefault, "Expected 'autoLogin' to be false, but it was \(userDefault)")

    }

    
    func testAutologinNoThrowError() async {
        // Given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        let saveEmail = "joe@gmail.com"
        let savePassword = "123456"
        UserDefaults.standard.set(saveEmail, forKey: "email")
        UserDefaults.standard.set(savePassword, forKey: "password")
        
        // When/Then
        do {
            try await authViewModel.autotoLogin()
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
