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
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Text("Aisles")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    List {
                        ForEach(aisles, id: \.self) { aisle in
                            NavigationLink(destination: MedicineListView(medicineStockViewModel: medicineStockViewModel, aisle: aisle)) {
                                
                                Text(aisle)
                                    .accessibilityLabel("Aisle \(aisle)")
                                    .accessibilityHint("Tap to view medicines in aisle \(aisle).")
                            }
                        }
                        .onDelete { IndexSet in
                            print("Indices reçus pour suppression : \(IndexSet)")
                            Task{
                                try? await medicineStockViewModel.deleteAisle(at: IndexSet)
                            }
                        }
                    }
                   
                }
                
                Button(action: {
                    Task{
                        try await medicineStockViewModel.addRandomMedicine(user: identity)
                    }
                }) {
                    ZStack {
                        Circle()
                            .frame(height: 60)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }
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
