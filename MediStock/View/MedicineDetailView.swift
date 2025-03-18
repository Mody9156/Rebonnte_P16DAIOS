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
    @State private var stockChange: Int = 0
    @State private var previewStrock: Int = 0
    var step = 1
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
                        let oldValue = Int(stockValue)
                        stockChange =  oldValue - previewStrock
                        previewStrock = oldValue
                        
                        try? await medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "", stock: stockChange)
                        try? await medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "", stock: stockChange)
                        guard let id = medicine.id else { return }
                        try? await  medicineStockViewModel.changeStock(medicine, user: id, stocks: stockChange, stockValue: stockChange)
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
                step: 1,
                label: { Text("Stock") },
                minimumValueLabel: { Text("0")},
                maximumValueLabel: { Text("100")}
            )
            .onChange(of: stockValue) { newValue in
                let stockValue = Int(stockValue)
                self.medicine.stock = Int(Double(stockValue))
            }
            .accessibilityLabel("Stock Slider")
            .accessibilityHint("Adjust the stock quantity with a slider.")
        }
        .onAppear{
            stockValue = Double(medicine.stock)
            previewStrock = medicine.stock
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
                    ForEach(filterMedicine.prefix(3)) { history in
                        HStack{
                            Text(history.timestamp.formatted(date: .numeric, time: .shortened))
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            Text("Stock: \(String(history.stock > 0 ? "Added +" : "Removed "))\(abs(history.stock))")
                                .font(.subheadline)
                                .foregroundStyle(history.stock > 0 ? .green : .red)
                        }
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(filterMedicine) { entry in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 250, height: 150)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "circle.fill")
                                                .foregroundColor(.blue)
                                            Text(entry.action)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        TextForShowDetails(value: entry.user, text: "User:")
                                        TextForShowDetails(value: entry.timestamp.formatted(), text: "Date:")
                                        TextForShowDetails(value: entry.details, text: "Details:")
                                        
                                        HStack {
                                            Text("Stock:")
                                                .fontWeight(.bold)
                                            Text("\(String(entry.stock > 0 ? "Added +" : "Removed "))\(abs(entry.stock))")
                                                .font(.subheadline)
                                                .foregroundStyle(entry.stock > 0 ? .green : .red)
                                        }
                                    }
                                    .padding()
                                )
                                .accessibilityElement(children: .combine)
                                .accessibilityHint("Details of this history entry.")
                        }
                    }
                    .padding(.horizontal)
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


struct TextForShowDetails:View {
    var value: String
       var text: String

       var body: some View {
           HStack {
               Text(text)
                   .fontWeight(.bold)
               Text(value)
                   .foregroundColor(.gray)
           }
       }
}
