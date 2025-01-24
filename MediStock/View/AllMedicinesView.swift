import SwiftUI

struct AllMedicinesView: View {
    @ObservedObject var viewModel = MedicineStockViewModel()
    @State private var filterText: String = ""
    @State private var email = UserDefaults.standard.string(forKey: "email")
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
                                    try await viewModel.trieElements(option: index)
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
                        NavigationLink(destination: MedicineDetailView(medicine: medicine, viewModel: viewModel)) {
                            VStack(alignment: .leading) {
                                Text(medicine.name)
                                    .font(.headline)
                                Text("Stock: \(medicine.stock)")
                                    .font(.subheadline)
                            }
                        }
                    }.onDelete { IndexSet in
                        viewModel.deleteMedicines(at: IndexSet)
                    }
                }
                .navigationBarItems(trailing: Button(action: {
                    Task{
                        guard let email else {return}
                        try await viewModel.addRandomMedicine(user: identity)
                    }
                }) {
                    Image(systemName: "plus")
                })
                .navigationBarTitle("All Medicines")
            }
        }
        .onAppear {
            viewModel.observeMedicines()
        }
    }
    
    var searchResult : [Medicine] {
        if filterText.isEmpty {
            return viewModel.medicines
        }else{
            return viewModel.medicines.filter{ $0.name.contains(filterText) }
        }
    }
}

struct AllMedicinesView_Previews: PreviewProvider {
    static var previews: some View {
        AllMedicinesView()
    }
}
