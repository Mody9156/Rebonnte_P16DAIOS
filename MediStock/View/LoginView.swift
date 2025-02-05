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
                ZStack{
                    Rectangle()
                        .frame(height: 200)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    VStack{
                        VStack(alignment: .leading){
                            Text("EMAIL")
                                .padding()
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                      
                            
                        VStack(alignment: .leading) {
                            Text("PASSWORD")
                                .padding()
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                       
                    }
                    
                  
                    
                }
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
                    .frame(width:100, height: 40)
                    
                Text(text)
                    .foregroundColor(.white)
            }
        }
    }
}
