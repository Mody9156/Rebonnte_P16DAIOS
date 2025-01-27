//
//  User.swift
//  pack
//
//  Created by KEITA on 09/01/2025.
//

import Foundation

public struct User {
    public var uid: String
    public var email: String?
    
    init(uid: String, email: String? = nil) {
        self.uid = uid
        self.email = email
    }
    
    
}
