import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject private var authViewModel = AuthViewModel()
    @Binding var selectedAutoConnection: Bool
    @AppStorage("toggleDarkMode") private var toggleDarkMode: Bool = false
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.2)
            
            VStack(alignment: .leading) {
                
                
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("BackgroundGreen"))
                        .opacity(0.8)
                        .frame(height: 200)
                    
                    VStack(spacing: 15) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Email")
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 10)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Password")
                                .foregroundColor(.white)
                                .padding(.leading, 10)
                            
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding()
                }
                
                HStack {
                    Button {
                        withAnimation {
                            selectedAutoConnection.toggle()
                            authViewModel.saveAutoConnectionState(selectedAutoConnection)
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                                .border(.green, width: 2)
                                .cornerRadius(2)
                            
                            if selectedAutoConnection {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                    .font(.system(size: 14, weight: .bold))
                            }
                        }
                    }
                    .padding(.leading)
                    
                    Text("Stay signed in")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                        .padding(.leading, 5)
                }
                .padding()
                
                ButtonForUpdateSession(email: $email, password: $password, text: "Login")
                ButtonForUpdateSession(email: $email, password: $password, text: "Sign Up")
            }
            .padding()
        }
        .preferredColorScheme(toggleDarkMode ? .dark : .light)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selected: Bool = false
        var body: some View {
            LoginView(selectedAutoConnection: $selected).environmentObject(SessionStore())
        }
    }
    return PreviewWrapper()
}

struct ButtonForUpdateSession: View {
    @Binding var email: String
    @Binding var password: String
    @StateObject var authViewModel = AuthViewModel()
    @State private var visible: Bool = false
    var text: String
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                Task {
                    if text == "Login" {
                        try await authViewModel.login(email: email, password: password)
                    } else {
                        try await authViewModel.createdNewUser(email: email, password: password)
                    }
                    
                    visible = true
                    ThorowsMessagesError()
                }
            }) {
                Text(text)
                    .foregroundColor(text == "Login" ? .white : .green)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(text == "Login" ? Color("BackgroundGreen") : Color.clear) 
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("BackgroundGreen"), lineWidth: 2)
                    )
            }
            .padding(.horizontal, 20)
            
            if visible && !authViewModel.messageError.isEmpty {
                Text(authViewModel.messageError)
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding(.horizontal, 10)
                    .transition(.opacity)
                    .animation(.easeOut(duration: 0.7), value: visible)
            }
        }
        .onChange(of: authViewModel.messageError) { newValue in
            visible = !newValue.isEmpty
            ThorowsMessagesError()
        }
    }
    
    private func ThorowsMessagesError() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                visible = false
            }
        }
    }
}
