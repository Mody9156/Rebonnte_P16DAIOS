//
//  AuthViewModelTests.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//

import Testing
@testable import pack

final class AuthViewModelTests {
    
    @Test func loginWithRighValues() async throws {
        //given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //when
         try? await authViewModel.login(email: "joe@gmail.com", password: "123456")
        //Then
        #expect(authViewModel.messageError.isEmpty)
        #expect(mockAuthService.isAuthenticated)
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    
    @Test func emailOrPasswordIsInvalid() async throws {
        //given
        let mockAuthService =  MockAuthViewModel()
        let authViewModel = AuthViewModel(session: mockAuthService)
        //when
        try? await authViewModel.login(email: "joe@gmail.com", password: "")
        //Then
        #expect(mockAuthService.messageError == "Erreur lors de la connexion")
        await #expect(throws: (ShowErrors.loginThrowError), performing: {
            try await authViewModel.login(email: "joe@gmail.com", password: "whrongPassword")
        })
        #expect(!mockAuthService.isAuthenticated)
    }

    
    @Test func testCreatedNewUserDoesNotThrowError() async throws {
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
    
    @Test func testCreatedNewUserWithSameEmailThrowError() async throws {
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
    
    @Test func disableNoThrowError() async throws {
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
}
