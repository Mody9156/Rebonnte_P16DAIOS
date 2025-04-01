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
                       
                        HStack {
                            Image("stethoscope")
                                .resizable()
                                    .scaledToFit()
                                    .frame(width: 101, height: 101)
                                    .foregroundColor(.black)
                                    .padding()
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                            
                            Spacer()
                            
                            VStack(alignment: .leading){
                                Text("Email Address:")
                                    .foregroundColor(Color("TextColor"))
                                    .padding(.bottom, 5)
                                
                                Text(identity)
                                    .foregroundColor(Color("TextColor"))
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    
                    Toggle(isOn: Binding(
                        get: { toggleDarkMode },
                        set:{newValue in
                            toggleDarkMode = newValue
                            hasUserChosenMode = true
                        }
                    ) ) {
                        Label(toggleDarkMode ? "Light Mode" : "Dark Mode", systemImage: toggleDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.gray)
                    }
                    .tint(.accentColor)
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
//
//#Preview{
//    Profile(authViewModel : AuthViewModel(), use: User(uid: "f4d6s"))
//}
