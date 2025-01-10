import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject var authViewModel : AuthViewModel
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                authViewModel.login(email: email, password: password)
            }) {
                Text("Login")
            }
            Button(action: {
                authViewModel.createdNewUser(email: email, password: password)
            }) {
                Text("Sign Up")
            }
            
            Text(authViewModel.messageError)
                .foregroundColor(.red)
                .font(.title2)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthViewModel(user: User(uid: "info"))).environmentObject(SessionStore())
    }
}
