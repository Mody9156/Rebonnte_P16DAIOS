import SwiftUI

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    @EnvironmentObject var session: SessionStore
    @AppStorage("email") var identity : String = "email"
    @FocusState var isTyping : Bool
    @FocusState var isTypingMedicine : Bool
    @State var isPresented : Bool = false
    var filterMedicine : [HistoryEntry]{
        return  medicineStockViewModel.history.filter ({
            $0.medicineId == medicine.id
        })
    }
    
    @State var animation : Bool = false

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
                
                // History Section
                historySection
                
                
               
            }
            .padding(.horizontal)
            .padding(.vertical)
            .navigationBarTitle("Medicine Details", displayMode: .inline)
            .onAppear{
                medicineStockViewModel.fetchHistory(for: medicine)
                
            }
            .onChange(of: medicine) { newMedicine in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
}

extension MedicineDetailView {
    private var medicineNameSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Name")) // prise en charge des langues
                .font(.largeTitle)
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityLabel("Name Label")
            
            VStack {
                ZStack(alignment: .leading) {
                    VStack {
                        ZStack(alignment: .leading) {
                            TextField("", text: $medicine.name, onCommit: {
                                Task{
                                    try? await medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                                }
                            })
                            .padding(.leading)
                            .frame(height: 55)
                            .focused($isTyping)
                            .foregroundStyle(isTyping ? .black : Color.clear)
                            .background(.black, in:RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 1))
                            .accessibilityLabel("Medicine Name Field")
                            .accessibilityHint("Edit the name of the medicine.")
                            
                            Text(LocalizedStringKey("Name")) // prise en charge des langues
                                .padding(.horizontal,5)
                                .background()
                                .background(.black.opacity(isTyping || !medicine.name.isEmpty ? 1:0))
                                .foregroundStyle(isTyping  || !medicine.name.isEmpty ? .black : Color.primary)
                                .padding(.leading)
                                .offset(y:isTyping ? -27:0)
                                .onTapGesture {
                                    isTyping.toggle()
                                }
                                .accessibilityLabel("Name Label")
                        }
                        .animation(.linear(duration: 0.2),value: isTyping)
                        
                    }
                }
            }
        }
    }
    private var medicineStockSection: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Stock"))
                .font(.largeTitle)
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityLabel("Stock Label")
            
            HStack{
                Spacer()
                Button(action: decreaseStock) {
                    ZStack {
                        Circle()
                            .frame(height: 50)
                            .foregroundStyle(.blue)
                            .opacity(0.8)

                        Image(systemName: "minus")
                            .resizable()
                            .frame(width: 20,height: 4)
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                }
                .accessibilityLabel("Decrease stock")
                .accessibilityHint("Reduce the stock quantity by 1.")
                
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter())
                    .frame(width: 100,height: 55)
                    .background(.black, in:RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 1))
                    .keyboardType(.numberPad)
                    .onChange(of: medicine.stock) { newValue in
                        if newValue < 0 { medicine.stock = 0 }
                    }
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Stock Field")
                    .accessibilityHint("Enter the current stock of the medicine.")
                
                Button(action: increaseStock) {
                    ZStack {
                        Circle()
                            .frame(height: 50)
                            .foregroundStyle(.blue)
                            .opacity(0.8)
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20,height: 20)
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
                .font(.largeTitle)
                .font(.headline)
                .foregroundStyle(.black)
                .accessibilityLabel("Aisle Label")
            
            
            VStack {
                VStack(alignment: .leading) {
                    
                    ZStack (alignment: .leading) {
                        TextField("", text: $medicine.aisle)
                            .onChange(of: medicine, perform: { _ in
                                Task{
                                    try? await medicineStockViewModel.updateMedicine(medicine, user: session.session?.uid ?? "")
                                }
                            })
                            .padding(.leading)
                            .frame(height: 55)
                            .background(.black, in:RoundedRectangle(cornerRadius: 14).stroke(lineWidth: 1))
                            .focused($isTypingMedicine)
                            .foregroundStyle(isTypingMedicine ? .black: .clear)
                            .accessibilityLabel("Aisle Field")
                            .accessibilityHint("Edit the aisle where the medicine is located.")
                        
                        Text(LocalizedStringKey("Name")) // prise en charge des langues
                            .padding(.horizontal,5)
                            .background()
                            .foregroundStyle(isTypingMedicine  || !medicine.aisle.isEmpty ? .black : .black)
                            .padding(.leading)
                            .offset(y:isTypingMedicine ? -27:0)
                            .onTapGesture {
                                isTypingMedicine.toggle()
                            }
                            .accessibilityLabel("Name Label")
                    }
                    .animation(.linear(duration: 0.2),value: isTyping)
                    
                }
            }
        }
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
            Button(action:{
                isPresented = true
            }){
                
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

#Preview{
    let sampleMedicine = Medicine(name: "Sample", stock: 10, aisle: "Aisle 1")
    //        let history = [
    //            HistoryEntry(medicineId: "gdfgfj84hrt", user: "Medicine 1", action: "Increment new user", details: "There are new update"),
    //            HistoryEntry(medicineId: "gdfgfj84hrt", user: "Medicine 1", action: "Increment new user", details: "There are new update"),
    //            HistoryEntry(medicineId: "gdfgfj84hrt", user: "Medicine 1", action: "Increment new user", details: "There are new update")]
    let sampleViewModel = MedicineStockViewModel()
    MedicineDetailView(medicine: sampleMedicine, medicineStockViewModel: sampleViewModel).environmentObject(SessionStore())
}
