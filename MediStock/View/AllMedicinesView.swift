import SwiftUI

struct AllMedicinesView: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @State private var filterText: String = ""
    @AppStorage("email") var identity : String = "email"
    @State var isSelected : String = ""
    @State private var activeView: Bool = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                Color(.gray)
                    .ignoresSafeArea()
                    .opacity(0.1)
                
                VStack(alignment: .leading){
                    // Filtrage et Tri
                    HStack {
                        TextField("Filter by name", text: $filterText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading, 10)
                            .accessibilityLabel("Filter medicines")
                            .accessibilityHint("Enter the name of the medicine to filter the list.")
                        Spacer()
                    }
                    .padding(.top, 10)
                    
                    VStack  {
                        HStack{
                            ForEach(MedicineStockViewModel.FilterOption.allCases, id:\.self){ index in
                                FilterButton(medicineStockViewModel: medicineStockViewModel, index:index.rawValue, isSelected:$isSelected)
                            }
                        }
                    }
                    .padding()
                    // Liste des Médicaments
                    ListView(medicineStockViewModel: medicineStockViewModel, filterText:$filterText)
                }
                
                Circle()
                    .frame(height: 200)
                    .position(x: 1, y: -87)
                    .foregroundStyle(.blue)
                    .opacity(0.4)
                
                Circle()
                    .frame(height: 200)
                    .position(x: 400, y: 710)
                    .foregroundStyle(.blue)
                    .opacity(0.4)
                
                Button {
                    Task{
                        try? await medicineStockViewModel.addRandomMedicine(user: identity)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .frame(height: 60)
                            .foregroundStyle(.blue)
                            .opacity(0.9)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .accessibilityLabel("Add random medicine")
                            .accessibilityHint("Adds a new random medicine to the list.")
                    }
                }
                .padding()
                .navigationBarTitle("All Medicines")
                .accessibilityLabel("All Medicines View")
                .accessibilityHint("Displays a list of all medicines and allows filtering or sorting.")
            }
        }
        .onAppear {
            Task{
                medicineStockViewModel.observeMedicines()
            }
        }
    }
}


#Preview {
    AllMedicinesView()
}

struct FilterButton: View {
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    var index : String
    @Binding var isSelected : String
    
    var body: some View {
        Button {
            Task{
                try await medicineStockViewModel.trieElements(option: MedicineStockViewModel.FilterOption(rawValue: index) ?? .noFilter)
            }
            isSelected = index
            
        } label: {
            ZStack {
                Rectangle()
                    .fill(isSelected == index ? Color.blue.opacity(0.7) : Color.black.opacity(0.8))
                    .frame(width: 80, height: 44)
                    .cornerRadius(12)
                
                Text("\(index)")
                    .foregroundStyle(.white)
            }
        }
        .accessibilityLabel("Sort by \(index)")
        .accessibilityHint("Sort the medicines based on \(index).")
    }
}

struct ListView: View {
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    @Binding var filterText : String
    var body: some View {
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
    }
    
    var searchResult : [Medicine] {
        if filterText.isEmpty {
            return medicineStockViewModel.medicines
        }else{
            return medicineStockViewModel.medicines.filter{ $0.name.contains(filterText) }
        }
    }
}
