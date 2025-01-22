import SwiftUI

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @StateObject var viewModel : MedicineStockViewModel
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(medicine.name)
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                // Medicine Name
                medicineNameSection
                
                // Medicine Stock
                medicineStockSection
                
                // Medicine Aisle
                medicineAisleSection
                
                // History Section
                historySection
            }
            .padding(.vertical)
            
        }
        .navigationBarTitle("Medicine Details", displayMode: .inline)
        .onAppear{
            viewModel.fetchHistory(for: medicine)
        }
        .onChange(of: medicine) { _ in
            viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
        }
        
    }
}

extension MedicineDetailView {
    private var medicineNameSection: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.headline)
            TextField("Name", text: $medicine.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    private var medicineStockSection: some View {
        VStack(alignment: .leading) {
            Text("Stock")
                .font(.headline)
            HStack {
                Button(action: {decreaseStock}) {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .accessibilityLabel("Decrease stock")
                
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                    .onChange(of: medicine.stock) { newValue in
                        if newValue < 0 { medicine.stock = 0 }
                    }
                
                Button(action: {
                    guard let id = medicine.id
                    else{return}
                    viewModel.increaseStock(medicine, user: id)
                    
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .accessibilityLabel("Increase stock")
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    private var medicineAisleSection: some View {
        VStack(alignment: .leading) {
            Text("Aisle")
                .font(.headline)
            TextField("Aisle", text: $medicine.aisle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    private func decreaseStock(){
        guard let id = medicine.id else{return}
        viewModel.decreaseStock(medicine, user: id)
        medicine.stock = max(0, medicine.stock - 1)
    }
    
    private var historySection: some View {
        VStack(alignment: .leading) {
            Text("History")
                .font(.headline)
                .padding(.top, 20)
            ScrollView(.vertical) {
                ForEach(viewModel.history.filter { $0.medicineId == medicine.id }) { entry in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(entry.action)
                            .font(.headline)
                        Text("User: \(entry.user)")
                            .font(.subheadline)
                        Text("Date: \(entry.timestamp.formatted())")
                            .font(.subheadline)
                        Text("Details: \(entry.details)")
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.bottom, 5)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
        let sampleViewModel = MedicineStockViewModel()
        MedicineDetailView(medicine: sampleMedicine, viewModel: sampleViewModel).environmentObject(SessionStore())
    }
}
