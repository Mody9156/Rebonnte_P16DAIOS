import SwiftUI

struct AisleListView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()
    @State private var email = UserDefaults.standard.string(forKey: "email")
    @State private var uid = UserDefaults.standard.string(forKey: "uid")
    
    var aisles: [String] {
        viewModel.aisles.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(aisles, id: \.self) { aisle in
                    NavigationLink(destination: MedicineListView(aisle: aisle)) {
                        Text(aisle)
                    }
                }
            }
            .navigationBarTitle("Aisles")
            .navigationBarItems(trailing:
             Button(action: {
                Task{
//                    guard let email = email else{return}
//                    guard let uid = uid else {return}
                    try await viewModel.addRandomMedicine(user: "test_user") // Remplacez par l'utilisateur actuel
                }
            }) {
                Image(systemName: "plus")
            })
        }
        .onAppear {
            viewModel.observeAisles()
        }
    }
    
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView()
    }
}
