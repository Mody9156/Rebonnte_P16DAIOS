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
                VStack{
                    Text("Account")
                        .foregroundStyle(.blue)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 110)
                            .foregroundStyle(.blue)
                            .opacity(0.4)
                        
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 101,height: 101)
                                .foregroundStyle(.blue)
                            
                            Spacer()
                            
                            VStack(alignment: .leading){
                                Text("Email Adresse: ")
                                    .foregroundColor(.blue)
                                Text(identity)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                }
                Spacer()
                
                Button(action:{
                    Task {
                        try await authViewModel.disableAutoLogin()
                    }
                }) {
                    Text("Se Déconnecter")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
    }
}

#Preview{
    Profile(authViewModel : AuthViewModel(), use: User(uid: "f4d6s"))
}
