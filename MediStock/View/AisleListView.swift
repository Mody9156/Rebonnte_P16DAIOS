import SwiftUI

struct AisleListView: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("email") var identity : String = "email"
    var aisles: [String] {
        medicineStockViewModel.aisles.sorted{$0.localizedStandardCompare( $1) == .orderedAscending }
    }
    @State private var activeView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color(.gray)
                    .ignoresSafeArea()
                    .opacity(0.1)
                
                GeometryReader { geometry in
                    Circle()
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.blue)
                        .opacity(0.4)
                        .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.1)
                    
                    Circle()
                        .frame(width: 200, height: 200)
                        .foregroundStyle(.blue)
                        .opacity(0.4)
                        .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.9)
                }
                
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
           
                Button(action: {
//                    Task{
//                        try await medicineStockViewModel.addRandomAisle()
//                    }
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
        .accessibilityElement(children: .contain)
    }
}

#Preview{
    AisleListView(medicineStockViewModel: MedicineStockViewModel())
}
