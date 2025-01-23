import SwiftUI

struct AisleListView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()
    @State private var email = UserDefaults.standard.string(forKey: "email")
    
    var aisles: [String] {
        viewModel.aisles.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(aisles, id: \.self) { aisle in
                    NavigationLink(destination: MedicineListView(viewModel: viewModel, aisle: aisle)) {
                        Text(aisle)
                    }
                }
            }
            .navigationBarItems(trailing:
             Button(action: {
                Task{
                    guard let email else {return}
                    try await viewModel.addRandomMedicine(user: email)
                }
            }) {
                Image(systemName: "plus")
            })
            .navigationBarTitle("Aisles")
        }
        .onAppear {
            viewModel.observeAisles()
            viewModel.resetHistoryCollection()
        }
    }
}

struct AisleListView_Previews: PreviewProvider {
    static var previews: some View {
        AisleListView(viewModel: MedicineStockViewModel())
    }
}
