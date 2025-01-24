import SwiftUI

struct MedicineListView: View {
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    var aisle: String
    @AppStorage("email") var identity : String = "email"

    var filterMedicines : [Medicine] {
        return medicineStockViewModel.medicines.filter({ Medicine in
            Medicine.aisle == aisle
        })
    }
    
    var body: some View {
        List {
            ForEach(filterMedicines, id: \.id) { medicine in
                NavigationLink(destination: MedicineDetailView(medicine: medicine, medicineStockViewModel: medicineStockViewModel)) {
                    VStack(alignment: .leading) {
                        Text(medicine.name)
                            .font(.headline)
                        Text("Stock: \(medicine.stock)")
                            .font(.subheadline)
                    }
                }
            }
            .onDelete { IndexSet in
                medicineStockViewModel.deleteMedicines(at: IndexSet)
            }
        }
        .navigationBarItems(trailing:Button(action: {
            Task{
                try await medicineStockViewModel.addRandomMedicineToList(user: identity, aisle: aisle) // Remplacez par l'utilisateur actuel
            }
        }) {
            Image(systemName: "plus")
        })
        .navigationBarTitle(aisle)
        
        .onAppear {
            medicineStockViewModel.observeMedicines()
        }
    }
    
    struct MedicineListView_Previews: PreviewProvider {
        static var previews: some View {
            MedicineListView(medicineStockViewModel: MedicineStockViewModel(medicines: [Medicine(name: "", stock: 2, aisle: "")]), aisle: "Aisle 1").environmentObject(SessionStore())
        }
    }
}
