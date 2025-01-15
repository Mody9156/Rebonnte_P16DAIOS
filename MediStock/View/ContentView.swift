import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        VStack {
            Group {
                if authViewModel.isAuthenticated {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .onAppear{
                Task{
                    authViewModel.changeStatus()
                try await  authViewModel.disableAutoLogin()
                }
            }
         }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environmentObject(SessionStore())
//    }
//}
