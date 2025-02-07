import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                ZStack{
                    Rectangle()
                        .frame(height: 250)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    VStack{
                        VStack(alignment: .leading){
                            Text("Email")
                                .foregroundColor(.blue)
                                .padding(.leading)
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                                .foregroundColor(.blue)
                                .padding(.leading)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                    }
                }
                .padding()
                
                ButtonForUpdateSession(email: $email, password: $password, text:"Login")
                ButtonForUpdateSession(email: $email, password: $password, text:"Sign Up")
                
                if !authViewModel.messageError.isEmpty {
                    Text(authViewModel.messageError)
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            .padding()
        }
    }
}

#Preview{
    LoginView().environmentObject(SessionStore())
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
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(text == "Login" ? .blue : .clear)
                    .frame(width:100, height: 40)
                
                Text(text)
                    .foregroundColor(text == "Login" ? .white: .blue)
            }
        }
    }
}
