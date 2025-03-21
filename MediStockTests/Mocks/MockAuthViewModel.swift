//
//  MockAuthViewModel.swift
//  MediStockTests
//
//  Created by Modibo on 21/03/2025.
//

import Testing
@testable import pack

struct MockAuthViewModel : AuthViewModelProtocol{
    
    var isAuthenticated: Bool
    
    var messageError: String
    
    var onLoginSucceed: (() -> Void)?
    
    func login(email: String, password: String) async throws {
        <#code#>
    }
    
    func createdNewUser(email: String, password: String) async throws {
        <#code#>
    }
    
    func changeStatus() async throws {
        <#code#>
    }
    
    func disableAutoLogin() async throws {
        <#code#>
    }
    
    func saveAutoConnectionState(_ state: Bool) {
        <#code#>
    }
    
    func autotoLogin() async throws {
        <#code#>
    }
    


}
