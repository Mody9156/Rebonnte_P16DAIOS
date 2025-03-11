import SwiftUI

struct AisleListView: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("email") var identity : String = "email"
    var aisles: [String] {
        medicineStockViewModel.aisles.sorted{$0.localizedStandardCompare( $1) == .orderedAscending }
    }
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color(.gray)
                    .ignoresSafeArea()
                    .opacity(0.1)
                
                VStack {
                    
                    List {
                        ForEach(aisles, id: \.self) { aisle in
                            NavigationLink(destination: MedicineListView(medicineStockViewModel: medicineStockViewModel, aisle: aisle)) {
                                
                                Text(aisle)
                                    .accessibilityLabel("Aisle \(aisle)")
                                    .accessibilityHint("Tap to view medicines in aisle \(aisle).")
                            }
                        }
                        .onDelete { indexSet in
                            let originalIndices = indexSet.compactMap { indexSet in
                                medicineStockViewModel.aisles.firstIndex(of: aisles[indexSet])
                            }
                            print("Indices reçus pour suppression : \(indexSet)")
                            
                            Task {
                                try? await medicineStockViewModel.deleteAisle(at: IndexSet(originalIndices)) // Supprimer avec les noms réels
                            }
                        }
                    }
                }
                .navigationTitle("Aisle")

                Circle()
                    .frame(height: 200)
                    .position(x: 1, y: -140)
                    .foregroundStyle(.blue)
                    .opacity(0.4)
        
                Circle()
                    .frame(height: 200)
                    .position(x: 400, y: 710)
                    .foregroundStyle(.blue)
                    .opacity(0.4)
                
                Button(action: {
                    Task{
                        try await medicineStockViewModel.addRandomAisle()
                    }
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
                .padding()
                .accessibilityLabel("Aisle List")
                .accessibilityHint("Displays a list of aisles containing medicines.")
                
                Text(medicineStockViewModel.errorMessage)
                    .foregroundStyle(.red)
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
