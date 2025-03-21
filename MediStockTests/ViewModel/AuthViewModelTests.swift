//
//  AuthViewModelTests.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//

import Testing
@testable import pack
struct AuthViewModelTests {
    
    @Test func loginWithRighValues() async throws {
        //given
        let mockAuthService =  MockAuthViewModel()
        //when
         try? await mockAuthService.login(email: "joe@gmail.com", password: "123456")
        //Then
        #expect(mockAuthService.isAuthenticated)
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}
