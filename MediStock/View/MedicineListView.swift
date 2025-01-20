import SwiftUI

struct MedicineListView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()
    var aisle: String
    var medicine : [Medicine]
    
    var body: some View {
        List {
            ForEach(viewModel.medicines.filter({ Medicine in
                Medicine.aisle == aisle
            }), id: \.id) { medicine in
                NavigationLink(destination: MedicineDetailView(medicine: medicine)) {
                    VStack(alignment: .leading) {
                        Text(medicine.name)
                            .font(.headline)
                        Text("Stock: \(medicine.stock)")
                            .font(.subheadline)
                    }
                }
            }
            .onDelete { IndexSet in
                viewModel.deleteMedicines(at: IndexSet)
            }
        }
        .navigationBarItems(trailing:Button(action: {
            Task{
                try await viewModel.addRandomMedicineToList(user: "test_user1", aisle: aisle) // Remplacez par l'utilisateur actuel
            }
        }) {
            Image(systemName: "plus")
        })
        .navigationBarTitle(aisle)
        .onAppear {
            viewModel.observeMedicines()
        }
        .onChange(of: medicine) { newValue in
            viewModel.observeMedicines()
        }
    }
    
    struct MedicineListView_Previews: PreviewProvider {
        static var previews: some View {
            MedicineListView(aisle: "Aisle 1", medicine: [Medicine(name: "", stock: 22, aisle: "")]).environmentObject(SessionStore())
        }
    }
}
