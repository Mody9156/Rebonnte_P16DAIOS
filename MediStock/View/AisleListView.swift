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
                
                Button(action: {
                    Task{
                        try await medicineStockViewModel.addRandomMedicine(user: identity)
                    }
                }) {
                    ZStack {
                        
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
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
