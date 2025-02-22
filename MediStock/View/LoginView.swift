import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                ZStack{
                    Rectangle()
                        .frame(height: 250)
                        .foregroundColor(Color("RectangleDarkMode"))
                        .cornerRadius(12)
                    
                    VStack{
                        VStack(alignment: .leading){
                            Text("Email")
                                .foregroundColor(.blue)
                                .padding(.leading)
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .border(.blue,width:3)
                                .cornerRadius(3)
                                .padding()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                                .foregroundColor(.blue)
                                .padding(.leading)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .border(.blue,width:3)
                                .cornerRadius(3)
                                .padding()
                        }
                    }
                }
                .padding()
                
                ButtonForUpdateSession(email: $email, password: $password, text:"Login")
                ButtonForUpdateSession(email: $email, password: $password, text:"Sign Up")
                
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
    @State private var visible: Bool = false
    var text : String
    
    var body: some View {
        VStack{
            Button(action: {
                Task{
                    if text == "Login" {
                        try await authViewModel.login(email: email, password: password)
                    }else{
                        try await authViewModel.createdNewUser(email: email, password: password)
                    }
                    
                    visible = true
                    ThorowsMessagesError()
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
            
            if visible && !authViewModel.messageError.isEmpty{
                Text(authViewModel.messageError)
                    .foregroundColor(.red)
                    .font(.headline)
                    .opacity(visible ? 1 :0)
                    .animation(.easeOut(duration: 0.7),value:visible)
            }
        }
        .onChange(of: authViewModel.messageError){ newValue in
            visible = !newValue.isEmpty
            ThorowsMessagesError()
        }
    }
    
    private func ThorowsMessagesError(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){
            withAnimation {
                visible = false
            }
            
        }
    }
}
