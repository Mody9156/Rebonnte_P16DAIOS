import SwiftUI

struct AllMedicinesView: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @State private var filterText: String = ""
    @AppStorage("email") var identity : String = "email"
    
    var body: some View {
        NavigationView {
            VStack {
                // Filtrage et Tri
                HStack {
                    TextField("Filter by name", text: $filterText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 10)
                        .accessibilityLabel("Filter medicines")
                        .accessibilityHint("Enter the name of the medicine to filter the list.")
                    
                    Spacer()
                    
                    Menu("Sort by") {
                        ForEach(MedicineStockViewModel.FilterOption.allCases, id:\.self){ index in
                            Button(index.rawValue){
                                Task{
                                    try await medicineStockViewModel.trieElements(option: index)
                                }
                            }
                            .accessibilityLabel("Sort by \(index.rawValue)")
                            .accessibilityHint("Sort the medicines based on \(index.rawValue).")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.trailing, 10)
                    .accessibilityLabel("Sorting options")
                    .accessibilityHint("Tap to choose how to sort the medicines.")
                    
                }
                .padding(.top, 10)
                // Liste des Médicaments
                List {
                    ForEach(searchResult, id: \.id) { medicine in
                        NavigationLink(destination: MedicineDetailView(medicine: medicine, medicineStockViewModel: medicineStockViewModel)) {
                            VStack(alignment: .leading) {
                                Text(medicine.name)
                                    .font(.headline)
                                    .accessibilityLabel("Medicine name: \(medicine.name)")
                                
                                
                                Text("Stock: \(medicine.stock)")
                                    .font(.subheadline)
                                    .accessibilityLabel("Stock: \(medicine.stock)")
                                
                            }
                        }
                        .accessibilityHint("Tap to see more details about \(medicine.name).")
                        
                    }.onDelete { IndexSet in
                        Task{
                          try? await medicineStockViewModel.deleteMedicines(at: IndexSet)
                        }
                    }
                }
                .accessibilityLabel("List of medicines")
                .accessibilityHint("Shows all available medicines and their stock.")
                .navigationBarItems(trailing: Button(action: {
                    Task{
                        try await medicineStockViewModel.addRandomMedicine(user: identity)
                    }
                }) {
                    Image(systemName: "plus")
                        .accessibilityLabel("Add random medicine")
                        .accessibilityHint("Adds a new random medicine to the list.")
                })
                .navigationBarTitle("All Medicines")
                .accessibilityLabel("All Medicines View")
                .accessibilityHint("Displays a list of all medicines and allows filtering or sorting.")
            }
        }
        .onAppear {
            medicineStockViewModel.observeMedicines()
        }
    }
    
    var searchResult : [Medicine] {
        if filterText.isEmpty {
            return medicineStockViewModel.medicines
        }else{
            return medicineStockViewModel.medicines.filter{ $0.name.contains(filterText) }
        }
    }
}


#Preview {
    AllMedicinesView()
}
