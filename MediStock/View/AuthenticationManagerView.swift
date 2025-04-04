import SwiftUI

struct AuthenticationManagerView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var authViewModel = AuthViewModel()
    @State var selectedAutoConnection: Bool = UserDefaults.standard.bool(forKey: "autoLogin")
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false
    
    var body: some View {
        VStack {
            Group {
                if authViewModel.isAuthenticated {
                    if selectedAutoConnection {
                        LoadingView()
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        selectedAutoConnection = false
                                    }
                                }
                            }
                    }else {
                        MainTabView()
                            .accessibilityLabel("Main Application View")
                            .accessibilityHint("Navigates to the main application content.")
                    }
                   
                } else {
                    LoginView(selectedAutoConnection: $selectedAutoConnection)
                        .accessibilityLabel("Login Scrren")
                        .accessibilityHint("Allows you to log in to your account.")
                }
            }
            .onAppear{
                Task{
                    if  selectedAutoConnection {
                        try await authViewModel.autotoLogin()
                    }
                    else{
                        try? await authViewModel.disableAutoLogin()
                    }
                    try? await authViewModel.changeStatus()
                }
            }
            .onDisappear {
                Task{
                    try? await  authViewModel.changeStatus()
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Authentication Manager")
        .accessibilityHint("Determines if the user is logged in or needs to log in.")
    }
}



#Preview {
    AuthenticationManagerView()
}
