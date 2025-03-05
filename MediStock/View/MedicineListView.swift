import SwiftUI

struct MedicineListView: View {
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    var aisle: String
    @AppStorage("email") var identity : String = "email"
    
    var filterMedicines : [Medicine] {
        return medicineStockViewModel.medicines.filter({ Medicine in
             return   Medicine.aisle == aisle
        })
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            List {
                ForEach(filterMedicines, id: \.id) { medicine in
                    NavigationLink(destination: MedicineDetailView(medicine: medicine, medicineStockViewModel: medicineStockViewModel)) {
                        VStack(alignment: .leading) {
                            Text(medicine.name)
                                .font(.headline)
                                .accessibilityLabel("Medicine Name: \(medicine.name)")
                                .accessibilityHint("Tap to view details for \(medicine.name).")
                            
                            Text("Stock: \(medicine.stock)")
                                .font(.subheadline)
                                .accessibilityLabel("Stock available: \(medicine.stock)")
                        }
                    }
                }
                .onDelete { IndexSet in
                    Task{
                            try?  await medicineStockViewModel.deleteMedicines(at: IndexSet)
                    }
                }
            }
            
            Button(action: {
                Task{
                        try? await medicineStockViewModel.addRandomMedicineToList(user: identity, aisle: aisle) // Remplacez par l'utilisateur actuel
                }
            }) {
                ZStack {
                    Circle()
                        .frame(height: 60)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .accessibilityLabel("Add random medicine")
                        .accessibilityHint("Adds a random medicine to the current aisle.")
                }
            }
            .accessibilityLabel("List of medicines in \(aisle)")
            .accessibilityHint("Displays all medicines available in \(aisle).")
            .onAppear {
                medicineStockViewModel.observeMedicines()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(aisle)
            }
        }
    }
}

#Preview{
    MedicineListView(medicineStockViewModel: MedicineStockViewModel(medicines: [Medicine(name: "", stock: 2, aisle: "")]), aisle: "Aisle 1").environmentObject(SessionStore())
}
