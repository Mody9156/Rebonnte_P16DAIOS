import SwiftUI

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @StateObject var viewModel : MedicineStockViewModel
    @EnvironmentObject var session: SessionStore
    @AppStorage("email") var identity : String = "email"

    var filterMedicine : [HistoryEntry]{
        return  viewModel.history.filter ({
            $0.medicineId == medicine.id
        })
    }

    var body: some View {
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
        
        .navigationBarTitle("Medicine Details", displayMode: .inline)
        .onAppear{
            viewModel.fetchHistory(for: medicine)
        }
        .onChange(of: medicine) { newMedicine in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if newMedicine == medicine {
                    viewModel.fetchHistory(for: newMedicine)
                }
            }
        }
    }
}

extension MedicineDetailView {
    private var medicineNameSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Name")) // prise en charge des langues
                .font(.headline)
            TextField("Name", text: $medicine.name, onCommit: {
                viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    private var medicineStockSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Stock"))
                .font(.headline)
            HStack {
                Button(action: decreaseStock) {
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
                
                Button(action: increaseStock) {
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
            Text(LocalizedStringKey("Aisle"))
                .font(.headline)
            TextField("Aisle", text: $medicine.aisle, onCommit: {
                viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
            })
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
    
    private func increaseStock(){
        guard let id = medicine.id else{return}
        viewModel.increaseStock(medicine, user: id)
        medicine.stock += 1
    }
    
    private var historySection: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("History")
                    .font(.headline)
                    .padding(.top, 20)
                
                ForEach(filterMedicine) { entry in
                    VStack(alignment: .leading,spacing: 5) {
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
            .padding(.horizontal)
        }
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
//        let history = [
//            HistoryEntry(medicineId: "gdfgfj84hrt", user: "Medicine 1", action: "Increment new user", details: "There are new update"),
//            HistoryEntry(medicineId: "gdfgfj84hrt", user: "Medicine 1", action: "Increment new user", details: "There are new update"),
//            HistoryEntry(medicineId: "gdfgfj84hrt", user: "Medicine 1", action: "Increment new user", details: "There are new update")]
        let sampleViewModel = MedicineStockViewModel()
        MedicineDetailView(medicine: sampleMedicine, viewModel: sampleViewModel).environmentObject(SessionStore())
    }
}
