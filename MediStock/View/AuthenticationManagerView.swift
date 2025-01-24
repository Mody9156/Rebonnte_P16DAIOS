import SwiftUI

struct AuthenticationManagerView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        VStack {
            Group {
                if authViewModel.isAuthenticated {
                    MainTabView()
                        .accessibilityLabel("Main Application View")
                        .accessibilityHint("Navigates to the main application content.")

                } else {
                    LoginView()
                        .accessibilityLabel("Login Scrren")
                        .accessibilityHint("Allows you to log in to your account.")


                }
            }
            .onAppear{
                Task{
                    authViewModel.changeStatus()
                    try await  authViewModel.disableAutoLogin()
                    
                }
            }
            .onDisappear {
                authViewModel.stopListeningToAuthChanges()
            }
        }
        .accessibilityElement(children: .contain) // Groups children as one accessibility element if needed
        .accessibilityLabel("Authentication Manager")
        .accessibilityHint("Determines if the user is logged in or needs to log in.")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationManagerView().environmentObject(SessionStore())
    }
}
