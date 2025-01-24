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
                    
                    Spacer()
                    
                    Menu("Sort by") {
                        ForEach(MedicineStockViewModel.FilterOption.allCases, id:\.self){ index in
                            Button(index.rawValue){
                                Task{
                                    try await medicineStockViewModel.trieElements(option: index)
                                }
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.trailing, 10)
                }
                .padding(.top, 10)
                // Liste des Médicaments
                List {
                    ForEach(searchResult, id: \.id) { medicine in
                        NavigationLink(destination: MedicineDetailView(medicine: medicine, viewModel: medicineStockViewModel)) {
                            VStack(alignment: .leading) {
                                Text(medicine.name)
                                    .font(.headline)
                                Text("Stock: \(medicine.stock)")
                                    .font(.subheadline)
                            }
                        }
                    }.onDelete { IndexSet in
                        medicineStockViewModel.deleteMedicines(at: IndexSet)
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    Task{
                        try await medicineStockViewModel.addRandomMedicine(user: identity)
                    }
                }) {
                    Image(systemName: "plus")
                })
                .navigationBarTitle("All Medicines")
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

struct AllMedicinesView_Previews: PreviewProvider {
    static var previews: some View {
        AllMedicinesView()
    }
}
