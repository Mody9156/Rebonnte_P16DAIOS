//
//  AuthViewModelTests.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//

@testable import pack
import Foundation

final class AuthViewModelTests {
    
    @Test
    func loginWithRighValues() async throws {
        //given
        let mockAuthService = MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //when
        try? await authViewModel.login(email: "joe@gmail.com", password: "123456")
        //Then
        #expect(authViewModel.messageError.isEmpty)
        #expect(mockAuthService.saveEmail == "joe@gmail.com" )
        #expect(mockAuthService.savePassword == "123456" )
        #expect(mockAuthService.isAuthenticated == true )
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test
    func emailOrPasswordIsInvalid() async throws {
        //given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When/Then
        await #expect(throws: (ShowErrors.loginThrowError)){
            try await authViewModel.login(email: "", password: "")
            #expect(!mockAuthService.isAuthenticated)
            #expect(mockAuthService.saveEmail == nil)
            #expect(mockAuthService.savePassword == nil)
        }
    }
    
    
    @Test
    func testCreatedNewUserDoesNotThrowError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When
        try? await authViewModel.createdNewUser(email: "joe_3@gmail.com", password: "123456")
        //Then
        await #expect(throws:Never.self) {
            try await authViewModel.createdNewUser(email: "joe_3@gmail.com", password: "123456")
        }
        #expect(mockAuthService.messageError.isEmpty)
        #expect(mockAuthService.isAuthenticated)
        #expect(mockAuthService.saveEmail == "joe_3@gmail.com")
        #expect(mockAuthService.savePassword == "123456")
        
    }
    
    @Test
    func testCreatedNewUserWithSameEmailThrowError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //when/Then
        await  #expect(throws: ShowErrors.createdNewUserThrowError) {
            try await authViewModel.createdNewUser(email: "joe@gmail.com", password: "123456")
            #expect(mockAuthService.messageError == "Erreur lors de la création de l'utilisateur")
            #expect(mockAuthService.isAuthenticated)
        }
    }
    
    @Test
    func disableNoThrowError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When
        try? await authViewModel.disableAutoLogin()
        //Then
        #expect(mockAuthService.messageError == "")
        await #expect(throws:Never.self){
            try await authViewModel.disableAutoLogin()
        }
        
    }
    
    @Test
    func disableThrowError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        mockAuthService.isAuthenticated = true
        //When
        try? await authViewModel.disableAutoLogin()
        //Then
        #expect(mockAuthService.messageError == "Erreur de déconnexion")
        await #expect(throws:ShowErrors.disableAutoLoginThrowError){
            try await authViewModel.disableAutoLogin()
        }
    }
    
    @Test
    func whenChangeStatusIsAuthenticatedThenCallOnChangeStatusAuthenticated() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When
        try? await authViewModel.changeStatus()
        //Given
        await #expect(throws:Never.self){
            try await authViewModel.changeStatus()
        }
        #expect(mockAuthService.messageError == "")
    }
    
    @Test
    func whenChangeStatusIsAuthenticatedThenCallOnChangeStatusAuthenticatedThrowError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        mockAuthService.isAuthenticated = true
        //When
        try? await authViewModel.changeStatus()
        //Given
        await #expect(throws:ShowErrors.changeStatusThrowError){
            try await authViewModel.changeStatus()
        }
        #expect(mockAuthService.messageError == "erreur de deconnexion")
    }
    
    @Test
    func whenYouWantSaveUserWithClickOnButtton() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When/Then
        await #expect(throws: Never.self){
            try await authViewModel.saveAutoConnectionState(true)
            let userDefault = UserDefaults.standard.bool(forKey: "autoLogin")
            #expect(userDefault == true)
        }
    }
    
    @Test
    func whenYouWantSaveUserWithNotClickOnButtton() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When/Then
        await #expect(throws:ShowErrors.loginThrowError){
            try await authViewModel.saveAutoConnectionState(false)
            let userDefault = UserDefaults.standard.bool(forKey: "autoLogin")
            #expect(userDefault == false)
        }
    }
    
    @Test
    func autologinNothrowError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        let saveEmail = "joe@gmail.com"
        let savePassword = "123456"
        UserDefaults.standard.set(saveEmail, forKey: "email")
        UserDefaults.standard.set(savePassword, forKey: "password")
        //When/Then
        await #expect(throws: Never.self) {
            try? await authViewModel.autotoLogin()
        }
    }
}
