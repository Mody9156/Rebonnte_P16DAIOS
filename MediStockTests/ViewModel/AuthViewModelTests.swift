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

}
