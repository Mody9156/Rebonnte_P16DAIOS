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
    @State var stocks : Bool = false
    
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
                        try? await  medicineStockViewModel.changeStock(medicine, user: id, stocks: medicine.stock)
                        
                    }
                } label: {
                    Text("Validate")
                        .foregroundColor(.white)
                        .frame(height: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                        .padding(.top, 10)
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
            Text(LocalizedStringKey("Stock"))
                .font(.title2)
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityLabel("Stock Label")
            
            HStack {
                Spacer()
                Button(action:{ medicine.stock -= 1}) {
                    ZStack {
                        Circle()
                            .frame(height: 50)
                            .foregroundStyle(.blue)
                            .opacity(0.8)
                        
                        Image(systemName: "minus")
                            .resizable()
                            .frame(width: 20, height: 4)
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .accessibilityLabel("Decrease stock")
                .accessibilityHint("Reduce the stock quantity by 1.")
                
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter())
                    .frame(width: 100, height: 55)
                    .background(.black, in: RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 1))
                    .keyboardType(.numberPad)
                    .onChange(of: medicine.stock) { newValue in
                        if newValue < 0 { medicine.stock = 0 }
                    }
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Stock Field")
                    .accessibilityHint("Enter the current stock of the medicine.")
                
                Button(action:{medicine.stock += 1}) {
                    ZStack {
                        Circle()
                            .frame(height: 50)
                            .foregroundStyle(.blue)
                            .opacity(0.8)
                        
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .accessibilityLabel("Increase stock")
                .accessibilityHint("Increase the stock quantity by 1.")
                Spacer()
            }
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
        .padding()
    }
}

#Preview {
    let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
    let sampleViewModel = MedicineStockViewModel()
    MedicineDetailView(medicine: sampleMedicine, medicineStockViewModel: sampleViewModel).environmentObject(SessionStore())
}
