import SwiftUI

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @ObservedObject var viewModel = MedicineStockViewModel()
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
                
                HStack {
                    Spacer()
                    
                    Button("Registre") {
                        
                        viewModel.changeStock(medicine, user: session.session?.uid ?? "", stocks: medicine.stock)
                        
                        viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                    }
                    .foregroundColor(.white)
                    .frame(width: 100,height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    Spacer()
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitle("Medicine Details", displayMode: .inline)
        
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
                Button(action: {
                    
                    medicine.stock -= 1
                }) {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter(), onCommit: {
                    viewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 100)
                
                Button(action: {
                    medicine.stock += 1
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
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
    
    private var historySection: some View {
        VStack(alignment: .leading) {
            Text("History")
                .font(.headline)
                .padding(.top, 20)
            ForEach(viewModel.history.filter { $0.medicineId == medicine.id }, id: \.id) { entry in
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
        .padding(.horizontal)
        .onChange(of: medicine, perform: { _ in
            viewModel.fetchHistory(for: medicine)
        }) 
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
        let sampleViewModel = MedicineStockViewModel()
        MedicineDetailView(medicine: sampleMedicine, viewModel: sampleViewModel).environmentObject(SessionStore())
    }
}
