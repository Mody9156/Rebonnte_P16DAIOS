//
//  Profile.swift
//  pack
//
//  Created by KEITA on 15/01/2025.
//

import SwiftUI

struct Profile: View {
    @StateObject var authViewModel : AuthViewModel
    var use : User
    var body: some View {
        VStack {
            Text("Profile")
            HStack {
                Text("Email")
                if let email = use.email{
                    Text(email)
                }
            }
            
            Button("Sign Out") {
                Task{
                    try await  authViewModel.disableAutoLogin()
                }
            }
            .foregroundColor(.white)
            .frame(width: 100, height: 50)
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(authViewModel : AuthViewModel(), use: User(uid: "f4d6s"))
    }
}
