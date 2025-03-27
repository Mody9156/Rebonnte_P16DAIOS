import SwiftUI

struct MedicineListView: View {
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    @State private var activeView: Bool = false
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false
    var aisle: String
    var filterMedicines : [Medicine] {
        return medicineStockViewModel.medicines.filter({ Medicine in
            return   Medicine.aisle == aisle
        })
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color("BackgroundColor_LD")
                .ignoresSafeArea()
            
            VStack {
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
                    .onDelete { Index in
                        let originalIndicesArray = Index.compactMap { index in
                            medicineStockViewModel.medicines.firstIndex(of: filterMedicines[index])
                        }
                        let originalIndices = IndexSet(originalIndicesArray)
                        Task{
                            try?  await medicineStockViewModel.deleteMedicines(at: originalIndices)
                        }
                    }
                }
            }
            .navigationTitle(aisle)
      
            Button(action: {
                activeView = true
            }) {
                ZStack {
                    Circle()
                        .frame(height: 60)
                        .foregroundStyle(.blue)
                        .opacity(0.9)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $activeView, onDismiss: {
                Task{
                    try await medicineStockViewModel.observeMedicines()
                }
            }) {
                AddMedicineView(nameInAisle: aisle)
            }
            .padding()
            .accessibilityLabel("Aisle List")
            .accessibilityHint("Displays a list of aisles containing medicines.")
            .accessibilityLabel("List of medicines in \(aisle)")
            .accessibilityHint("Displays all medicines available in \(aisle).")
            .onAppear {
                Task{
                    try await medicineStockViewModel.observeMedicines()
                }
                
            }
            
            .padding()
        }
    }
}

//#Preview{
//    MedicineListView(medicineStockViewModel: MedicineStockViewModel(medicines: [Medicine(name: "Aisle", stock: 500, aisle: "Jocker")]), aisle: "Aisle 1").environmentObject(SessionStore())
//}
