import SwiftUI

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    @EnvironmentObject var session: SessionStore
    @AppStorage("email") var identity : String = "email"
    
    var filterMedicine : [HistoryEntry]{
        return  medicineStockViewModel.history.filter ({
            $0.medicineId == medicine.id
        })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text(medicine.name)
                .font(.largeTitle)
                .padding(.top, 20)
                .accessibilityLabel("Medicine Name: \(medicine.name)")
            
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
            medicineStockViewModel.fetchHistory(for: medicine)
        }
        .onChange(of: medicine) { newMedicine in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if newMedicine == medicine {
                    medicineStockViewModel.fetchHistory(for: newMedicine)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Medicine Details")
        .accessibilityHint("Displays detailed information about the medicine.")
    }
}

extension MedicineDetailView {
    private var medicineNameSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Name")) // prise en charge des langues
                .font(.headline)
                .accessibilityLabel("Name Label")
            
            TextField("Name", text: $medicine.name, onCommit: {
                Task{
                   medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.bottom, 10)
            .accessibilityLabel("Medicine Name Field")
            .accessibilityHint("Edit the name of the medicine.")
        }
        .padding(.horizontal)
    }
    
    private var medicineStockSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Stock"))
                .font(.headline)
                .accessibilityLabel("Stock Label")
            
            HStack {
                Button(action: decreaseStock) {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .accessibilityLabel("Decrease stock")
                .accessibilityHint("Reduce the stock quantity by 1.")
                
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                    .onChange(of: medicine.stock) { newValue in
                        if newValue < 0 { medicine.stock = 0 }
                    }
                    .accessibilityLabel("Stock Field")
                    .accessibilityHint("Enter the current stock of the medicine.")
                
                Button(action: increaseStock) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .accessibilityLabel("Increase stock")
                .accessibilityHint("Increase the stock quantity by 1.")
                
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }
    
    private var medicineAisleSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Aisle"))
                .font(.headline)
                .accessibilityLabel("Aisle Label")
            
            TextField("Aisle", text: $medicine.aisle, onCommit: {
                Task{
                    try? await medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.bottom, 10)
            .accessibilityLabel("Aisle Field")
            .accessibilityHint("Edit the aisle where the medicine is located.")
        }
        .padding(.horizontal)
    }
    
    private func decreaseStock(){
        guard let id = medicine.id else{return}
        medicineStockViewModel.decreaseStock(medicine, user: id)
        medicine.stock = max(0, medicine.stock - 1)
    }
    
    private func increaseStock(){
        guard let id = medicine.id else{return}
        medicineStockViewModel.increaseStock(medicine, user: id)
        medicine.stock += 1
    }
    
    private var historySection: some View {
        VStack(alignment: .leading) {
            Text("History")
                .font(.headline)
                .padding(.top, 20)
                .accessibilityLabel("History Section")
                .accessibilityHint("Displays the history of actions for this medicine.")
            
            ScrollView {
                VStack {
                    ForEach(filterMedicine) { entry in
                        VStack(alignment: .leading,spacing: 5) {
                            Text(entry.action)
                                .font(.headline)
                                .accessibilityLabel("Action: \(entry.action)")
                            
                            Text("User: \(entry.user)")
                                .font(.subheadline)
                                .accessibilityLabel("Performed by: \(entry.user)")
                            
                            Text("Date: \(entry.timestamp.formatted())")
                                .font(.subheadline)
                                .accessibilityLabel("Date: \(entry.timestamp.formatted())")
                            
                            Text("Details: \(entry.details)")
                                .font(.subheadline)
                                .accessibilityLabel("Details: \(entry.details)")
                            
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                        .accessibilityElement(children: .combine)
                        .accessibilityHint("Details of this history entry.")
                    }
                }
            }
        }
        .padding(.horizontal)
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
        MedicineDetailView(medicine: sampleMedicine, medicineStockViewModel: sampleViewModel).environmentObject(SessionStore())
    }
}
