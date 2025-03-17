import SwiftUI

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    @EnvironmentObject var session: SessionStore
    @AppStorage("email") var identity : String = "email"
    @FocusState var isTyping : Bool
    @FocusState var isTypingMedicine : Bool
    @State var isPresented : Bool = false
    @State var animation : Bool = false
    @State private var stockValue: Double = 0.0
    
    var filterMedicine : [HistoryEntry] {
        return  medicineStockViewModel.history.filter {
            $0.medicineId == medicine.id
        }
    }
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.1)
            
            Circle()
                .frame(height: 200)
                .position(x: 1, y: 1)
                .foregroundStyle(.blue)
                .opacity(0.4)
            
            Circle()
                .frame(height: 200)
                .position(x: 400, y: 800)
                .foregroundStyle(.blue)
                .opacity(0.4)
            
            VStack(alignment: .leading, spacing: 20) {
                // Medicine Name
                medicineNameSection
                
                // Medicine Stock
                medicineStockSection
                
                // Medicine Aisle
                medicineAisleSection
                
                Button {
                    Task{
                        try? await medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                        try? await medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                        guard let id = medicine.id else { return }
                        try? await  medicineStockViewModel.changeStock(medicine, user: id, stocks: Int(stockValue))
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(height: 45)
                            .foregroundColor(.blue)
                            .cornerRadius(15)
                        
                        Text("Validate")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                
                // History Section
                historySection
                
            }
            .padding(.horizontal)
            .padding(.vertical)
            .navigationBarTitle("Medicine Details", displayMode: .inline)
            .onAppear {
                medicineStockViewModel.fetchHistory(for: medicine)
            }
            .onChange(of: medicine) { newMedicine in
                if newMedicine != medicine {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        medicineStockViewModel.fetchHistory(for: newMedicine)
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Medicine Details")
            .accessibilityHint("Displays detailed information about the medicine.")
            
        }
    }
}

extension MedicineDetailView {
    private var medicineNameSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Name")) // prise en charge des langues
                .font(.title2)
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityLabel("Name Label")
            
            VStack {
                ZStack(alignment: .leading) {
                    VStack {
                        TextField("", text: $medicine.name)
                            .padding(.leading)
                            .frame(height: 55)
                            .focused($isTyping)
                            .background(.black, in: RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 1))
                            .accessibilityLabel("Medicine Name Field")
                            .accessibilityHint("Edit the name of the medicine.")
                    }
                }
            }
        }
    }
    
    private var medicineStockSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Stock: \(Int(medicine.stock))"))
                .font(.title2)
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityLabel("Stock Label")
            
            Slider(
                value: $stockValue,
                in: 0...100,
                step: 1
            ){
                Text("Speed")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            } .onChange(of: stockValue ){ _ in
                medicine.stock = Int(stockValue)
            }
            .accessibilityLabel("Stock Slider")
            .accessibilityHint("Adjust the stock quantity with a slider.")
        }
        .onAppear{
            stockValue = Double(medicine.stock)
        }
    }
    
    private var medicineAisleSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Aisle"))
                .font(.title2)
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityLabel("Aisle Label")
            
            VStack {
                VStack(alignment: .leading) {
                    TextField("", text: $medicine.aisle)
                        .padding(.leading)
                        .frame(height: 55)
                        .background(.black, in: RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 1))
                        .focused($isTypingMedicine)
                        .accessibilityLabel("Aisle Field")
                        .accessibilityHint("Edit the aisle where the medicine is located.")
                }
            }
        }
    }
    
    private func decreaseStock() {
        guard let id = medicine.id else { return }
        Task{
            try? await medicineStockViewModel.decreaseStock(medicine, user: id)
        }
        medicine.stock = max(0, medicine.stock - 1)
    }
    
    private func increaseStock() {
        guard let id = medicine.id else { return }
        Task{
            try? await medicineStockViewModel.increaseStock(medicine, user: id)
        }
        medicine.stock += 1
    }
    
    private var historySection: some View {
        VStack(alignment: .leading) {
            Text("Hystory")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .accessibilityLabel("History Section")
            
            if filterMedicine.isEmpty {
                Text("No history available")
                   .foregroundColor(.gray)
                   .font(.subheadline)
                
            }else{
                
                VStack(alignment: .leading) {
                    
                }
                
                Button(action: {
                    isPresented = true
                }) {
                    ZStack {
                        Rectangle()
                            .frame(height: 45)
                            .foregroundColor(.blue)
                            .cornerRadius(15)
                        
                        Text("Show History")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
                .sheet(isPresented: $isPresented) {
                    HistoryView(filterMedicine: filterMedicine)
                }
            }
        }
        .padding()
    }
}

#Preview {
    let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
    let sampleViewModel = MedicineStockViewModel()
    MedicineDetailView(medicine: Medicine(name: "Paracetamol", stock: 44, aisle: "Anti-inflammatory"), medicineStockViewModel: MedicineStockViewModel()).environmentObject(SessionStore())
}
