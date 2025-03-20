import SwiftUI

struct AisleListView: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("email") var identity : String = "email"
    var aisles: [String] {
        medicineStockViewModel.aisles.sorted{$0.localizedStandardCompare( $1) == .orderedAscending }
    }
    @State private var activeView: Bool = false
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color("BackgroundColor_LD")
                    .ignoresSafeArea()
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
                .listStyle(.insetGrouped)
                .navigationTitle("Aisle")
                
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
                .sheet(isPresented: $activeView) {
                    AddANewAisle()
                }
                .padding()
                .accessibilityLabel("Aisle List")
                .accessibilityHint("Displays a list of aisles containing medicines.")
                
            }
            
            
        }
        .onAppear {
            medicineStockViewModel.observeAisles()
        }
        .preferredColorScheme(toggleDarkMode ? .dark : .light)
        .accessibilityElement(children: .contain)
    }
}

#Preview{
    AisleListView(medicineStockViewModel: MedicineStockViewModel())
}
