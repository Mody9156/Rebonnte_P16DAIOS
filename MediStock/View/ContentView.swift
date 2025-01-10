import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        VStack {
            Group {
                if authViewModel.session.session != nil {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .onAppear
            {
                authViewModel.changeStatus()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
