//
//  AuthViewModelProtocol.swift
//  pack
//
//  Created by Modibo on 21/03/2025.
//

import Foundation

protocol AuthViewModelProtocol {
    var isAuthenticated: Bool { get }  
    var messageError: String { get }
    var onLoginSucceed: (() -> Void)? { get set }
    
       func login(email: String, password: String) async throws
       func createdNewUser(email: String, password: String) async throws
       func changeStatus() async throws
       func disableAutoLogin() async throws
       func saveAutoConnectionState(_ state: Bool)
       func autotoLogin() async throws
}
