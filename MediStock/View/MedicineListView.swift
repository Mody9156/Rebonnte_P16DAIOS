import SwiftUI

struct MedicineListView: View {
    @StateObject var viewModel : MedicineStockViewModel
    var aisle: String
    @State private var email = UserDefaults.standard.string(forKey: "email")

    var filterMedicines : [Medicine] {
        return viewModel.medicines.filter({ Medicine in
            Medicine.aisle == aisle
        })
    }
    
    var body: some View {
        List {
            ForEach(filterMedicines, id: \.id) { medicine in
                NavigationLink(destination: MedicineDetailView(medicine: medicine, viewModel: viewModel, history: [HistoryEntry(medicineId: "", user: "", action: "", details: "", timestamp: Date.now)])) {
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
                guard let email else {return}
                try await viewModel.addRandomMedicineToList(user: email, aisle: aisle) // Remplacez par l'utilisateur actuel
            }
        }) {
            Image(systemName: "plus")
        })
        .navigationBarTitle(aisle)
        
        .onAppear {
            viewModel.observeMedicines()
        }
    }
    
    struct MedicineListView_Previews: PreviewProvider {
        static var previews: some View {
            MedicineListView(viewModel: MedicineStockViewModel(medicines: [Medicine(name: "", stock: 2, aisle: "")]), aisle: "Aisle 1").environmentObject(SessionStore())
        }
    }
}
