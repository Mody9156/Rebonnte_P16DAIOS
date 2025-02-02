import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject var authViewModel = AuthViewModel()
//    var LinearGradient : Color {
//        LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
//    }

    var body: some View {
        ZStack {
      
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                ButtonForUpdateSession(email: $email, password: $password, text:"Login")
                ButtonForUpdateSession(email: $email, password: $password, text:"Sign Up")
                
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
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 40)
                
                Text(text)
                    .foregroundColor(text == "Login" ? .white : .clear)
            }
        }
    }
}
