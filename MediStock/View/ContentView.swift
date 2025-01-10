import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var authViewModel : AuthViewModel
    var body: some View {
        VStack {
            Group {
                if authViewModel.session != nil {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .onAppear
            {
                session.listen()
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(authViewModel: AuthViewModel(user: User(uid: "Info"))).environmentObject(SessionStore())
    }
}
