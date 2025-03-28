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
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false
    @AppStorage("hasUserChosenMode") private var hasUserChosenMode : Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            
            VStack (alignment: .center){
                VStack{
                    Text("Account")
                        .foregroundStyle(Color("TextColor"))
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 110)
                            .foregroundStyle(.gray)
                        
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 101, height: 101)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            VStack(alignment: .leading){
                                Text("Email Adresse: ")
                                    .foregroundColor(Color("RectangleDarkMode"))
                                Text(identity)
                                    .foregroundColor(Color("RectangleDarkMode"))
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    
                    Toggle(isOn: $toggleDarkMode) {
                        Label(toggleDarkMode ? "Light Mode" : "Dark Mode", systemImage: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.gray)
                    }
                    .padding()
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
        //        .preferredColorScheme(hasUserChosenMode ? (toggleDarkMode ? .dark : .light) : nil)
        .animation(.easeInOut, value: toggleDarkMode)
    }
    
    
}

#Preview{
    Profile(authViewModel : AuthViewModel(), use: User(uid: "f4d6s"))
}
