import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var authViewModel = AuthViewModel()
    @Binding  var selectedAutoConnection : Bool
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.2)
            
            VStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.blue)
                        .frame(height: 250)
                        .foregroundColor(Color("BackgroundButton"))
                        .opacity(0.8)
                    
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
                    }
                }
                .padding()
                
                HStack {
                    Button {
                        withAnimation {
                            selectedAutoConnection.toggle()
                            authViewModel.saveAutoConnectionState(selectedAutoConnection)
                        }
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 20,height: 20)
                                .foregroundStyle(.blue)
                                .border(.blue,width: 2)
                            
                            if selectedAutoConnection {
                                Image(systemName: "xmark")
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .padding(.leading)
                    
                    Text("Stay signed in")
                        .foregroundStyle(.white)
                }
                
                ButtonForUpdateSession(email: $email, password: $password, text:"Login")
                ButtonForUpdateSession(email: $email, password: $password, text:"Sign Up")
                
            }
            .padding()
            
        }
        .preferredColorScheme(toggleDarkMode ? .dark : .light)
    }
}

#Preview{
    struct PreviewWrapper: View {
        @State var selected : Bool = false
        var body: some View
        {
            LoginView(selectedAutoConnection: $selected).environmentObject(SessionStore())
        }
    }
    return PreviewWrapper()
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
