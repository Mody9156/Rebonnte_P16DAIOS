import SwiftUI

struct AisleListView: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("email") var identity : String = "email"
    
    var aisles: [String] {
        medicineStockViewModel.aisles.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(aisles, id: \.self) { aisle in
                        NavigationLink(destination: MedicineListView(medicineStockViewModel: medicineStockViewModel, aisle: aisle)) {
                            Text(aisle)
                                .accessibilityLabel("Aisle \(aisle)")
                                .accessibilityHint("Tap to view medicines in aisle \(aisle).")
                        }
                    }
                }
                .navigationBarItems(trailing:Button(action: {
                    Task{
                        try await medicineStockViewModel.addRandomMedicine(user: identity)
                    }
                }) {
                    Image(systemName: "plus")
                })
                .navigationBarTitle("Aisles")
                .accessibilityLabel("Aisle List")
                .accessibilityHint("Displays a list of aisles containing medicines.")
                
                Button(action: {
                    Task{
                        try await medicineStockViewModel.addRandomMedicine(user: identity)
                    }
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 100, height: 50)
                }
                .padding()
                .navigationBarTitle("Aisles")
                .accessibilityLabel("Aisle List")
                .accessibilityHint("Displays a list of aisles containing medicines.")
            }
        }
        .onAppear {
            medicineStockViewModel.observeAisles()
        }
        .accessibilityElement(children: .contain)
    }
}

#Preview{
    AisleListView(medicineStockViewModel: MedicineStockViewModel())
}
