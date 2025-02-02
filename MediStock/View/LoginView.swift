import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                ButtonForUpdateSession(email: $email, password: $password, text:"Login")
                
                Button(action: {
                    Task{
                        try await authViewModel.createdNewUser(email: email, password: password)
                    }
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 40)
                            .cornerRadius(12)
                        
                        Text("Sign Up")
                            .foregroundColor(.white)
                    }
                }
                
                Text(authViewModel.messageError)
                    .foregroundColor(.red)
                    .font(.title2)
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(SessionStore())
    }
}

struct ButtonForUpdateSession: View {
    @Binding var email : String
    @Binding var password : String
    @StateObject var authViewModel = AuthViewModel()
    var text : String
    
    var body: some View {
        Button(action: {
            Task{
                if text == "Login" {
                    try await authViewModel.login(email: email, password: password)
                }else{
                    try await authViewModel.createdNewUser(email: email, password: password)
                }
            }
        }) {
            ZStack {
                Rectangle()
                    .frame(height: 40)
                    .cornerRadius(12)
                
                Text(text)
                    .foregroundColor(.white)
            }
        }
    }
}
