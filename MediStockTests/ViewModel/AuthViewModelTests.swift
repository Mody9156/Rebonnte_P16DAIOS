//
//  AuthViewModelTests.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//

import Testing
@testable import pack
import Foundation

final class AuthViewModelTests {
    
    @Test
    func loginWithRighValues() async throws {
        //given
        let mockAuthService =  MockAuthViewModel( )
        let authViewModel = AuthViewModel(session: mockAuthService)
        //when
        try? await authViewModel.login(email: "joe@gmail.com", password: "123456")
        //Then
        #expect(authViewModel.messageError.isEmpty)
        #expect(mockAuthService.isAuthenticated)
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
        try? await authViewModel.createdNewUser(email: "Jdoe@gmail.com", password: "fakePassword")
        //Then
        await #expect(throws:Never.self) {
            try await authViewModel.createdNewUser(email: "Jdoe@gmail.com", password: "fakePassword")
        }
        #expect(mockAuthService.messageError.isEmpty)
    }
    
    @Test
    func testCreatedNewUserWithSameEmailThrowError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //when
        try? await authViewModel.createdNewUser(email: "joe@gmail.com", password: "123456")
        //Then
        #expect(mockAuthService.messageError == "Erreur lors de la création de l'utilisateur")
        await  #expect(throws: ShowErrors.createdNewUserThrowError) {
            try await authViewModel.createdNewUser(email: "joe@gmail.com", password: "123456")
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
        #expect(mockAuthService.messageError == "erreur de deconnexion")
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
        #expect(mockAuthService.messageError == "erreur lors de la persistance de donné de l'utilisateur")
    }
    
    @Test
    func whenYouWantSaveUserWithClickOnButtton() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When
        authViewModel.saveAutoConnectionState(true)
        //Then
        let userDefault = UserDefaults.standard.bool(forKey: "autoLogin")
        #expect(userDefault == true)
    }
    
    @Test
    func whenYouWantSaveUserWithNotClickOnButtton() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //When
        authViewModel.saveAutoConnectionState(false)
        //Then
        let userDefault = UserDefaults.standard.bool(forKey: "autoLogin")
        #expect(userDefault == false)
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
        //When
        try? await authViewModel.login(email: saveEmail, password: savePassword)
        try? await authViewModel.autotoLogin()
        //Then
        #expect(mockAuthService.messageError == "")
        #expect(mockAuthService.savePassword == savePassword)
        #expect(mockAuthService.saveEmail == saveEmail)
    }
    
    @Test
    func autologinThrowºError() async throws {
        //Given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        mockAuthService.isAuthenticated = false
        let saveEmail = ""
        let savePassword = ""
        UserDefaults.standard.set(saveEmail, forKey: "email")
        UserDefaults.standard.set(savePassword, forKey: "password")
        //When
        do{
            try await authViewModel.autotoLogin()
        }catch{
            //Then
            #expect(mockAuthService.messageError == "Erreur lors de la connexion")
            #expect(mockAuthService.savePassword == nil)
            #expect(mockAuthService.saveEmail == nil)
        }
    }
}
