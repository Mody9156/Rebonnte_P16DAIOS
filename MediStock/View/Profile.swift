//
//  Profile.swift
//  pack
//
//  Created by KEITA on 15/01/2025.
//

import SwiftUI

struct Profile: View {
    @StateObject var authViewModel : AuthViewModel
    @AppStorage("email") var identity : String = "email"
    var use : User
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.1)
            
            Circle()
                .frame(height: 200)
                .position(x: 1, y: 1)
                .foregroundStyle(.blue)
                .opacity(0.4)
            
            Circle()
                .frame(height: 200)
                .position(x: 400, y: 800)
                .foregroundStyle(.blue)
                .opacity(0.4)

            
            VStack (alignment: .center){
                VStack (alignment: .leading){
                    Text("Account")
                        .foregroundStyle(.blue)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding()
                    
                    ZStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 80)
                            .foregroundStyle(.white)
                            .opacity(0.4)
                        
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 50,height: 50)
                                .foregroundStyle(.blue)
                            Spacer()
                            VStack(alignment: .leading){
                                Text("Email Adresse: ")
                                    .foregroundColor(.white)
                                Text(identity)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
                Spacer()
                
                Button(action:{
                    Task {
                        try await authViewModel.disableAutoLogin()
                    }
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .resizable()
                        .frame(width: 50,height: 50)
                        .foregroundStyle(.blue)
                }
            }
            .padding()
        }
    }
}

#Preview{
    Profile(authViewModel : AuthViewModel(), use: User(uid: "f4d6s"))
}
