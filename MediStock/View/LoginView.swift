import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var authViewModel = AuthViewModel()
    @State private var selectedAutoConnection : Bool = false
    
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
            
            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blue)
                        .frame(height: 250)
                        .foregroundColor(Color("BackgroundButton"))
                        .opacity(0.6)
                    
                    VStack{
                        VStack(alignment: .leading){
                            Text("Email")
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(3)
                                .padding()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Password")
                                .foregroundColor(.white)
                                .padding(.leading)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .cornerRadius(3)
                                .padding()
                        }
                        
                        Button {
                            selectedAutoConnection.toggle()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(width: 20,height: 20)
                                    .foregroundStyle(.white)
                                    .border(.blue,width: 2)
                            }
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
                Text(text)
                    .foregroundColor(text == "Login" ? .white : .blue)
                    .opacity(text == "Login" ? 1 : 0.6)
                    .frame(width: 100, height: 40)
                    .background(text == "Login" ? Color("BackgroundButton") : Color.clear)
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("BackgroundButton"), lineWidth: 2)
                    }
            }
            .padding()
            
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
