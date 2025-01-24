import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            AisleListView()
                .tabItem {
                    Image(systemName: "list.dash")
                        .accessibilityLabel("Aisles List Icon")
                    Text("Aisles")
                }
                .accessibilityLabel("Aisles")
                .accessibilityHint("View the list of aisles in the pharmacy.")
            
            AllMedicinesView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                        .accessibilityLabel("Medicines Grid Icon")
                    Text("All Medicines")
                }
                .accessibilityLabel("All Medicines")
                .accessibilityHint("View the list of all medicines available.")
            
            Profile(authViewModel: AuthViewModel(), use: User(uid: ""))
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                        .accessibilityLabel("Profile Icon")
                    Text("Profile")
                }
                .accessibilityLabel("Profile")
                .accessibilityHint("View and edit your profile information.")
        }
        .accessibilityLabel("Main Tab Bar")
        .accessibilityHint("Use the tabs to switch between different sections of the app.")
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
