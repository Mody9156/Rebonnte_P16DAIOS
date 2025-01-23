//
//  Profile.swift
//  pack
//
//  Created by KEITA on 15/01/2025.
//

import SwiftUI

struct Profile: View {
    @StateObject var authViewModel : AuthViewModel
    @State private var email = UserDefaults.standard.string(forKey: "email")
    @AppStorage("email") var identity : String = "email"
    var use : User
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Text("Hello")
                .font(.largeTitle)
            
            HStack{
                Text("Email : ")
                Text("Identity : \(identity)")
                    .foregroundColor(.red)
            }
            .padding()
            
            Spacer()
            
            Button("Sign Out") {
                Task{
                    try await  authViewModel.disableAutoLogin()
                }
            }
            .foregroundColor(.white)
            .frame(width:100, height: 50)
            .background(Color.red)
            .cornerRadius(12)
            Spacer()
        }
        .padding()
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(authViewModel : AuthViewModel(), use: User(uid: "f4d6s"))
    }
}
