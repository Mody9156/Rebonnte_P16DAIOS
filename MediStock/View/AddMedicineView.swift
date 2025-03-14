//
//  AddMedicineView.swift
//  pack
//
//  Created by Modibo on 14/03/2025.
//

import SwiftUI

struct AddMedicineView: View {
    @State private var stock : Double = 0.0
    @State private var stockSelected : Int = 0
    @State  var nameInAisle : String
    @State private var nameInAisleMEdicine : String = ""
    @Environment(\.dismiss) var dismiss
    @State var isEditing : Bool = false
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("email") var identity : String = "email"
    
    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.1)
            
            GeometryReader { geometry in
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.blue)
                    .opacity(0.4)
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.1)
                
                Circle()
                    .frame(width: 200, height: 200)
                    .foregroundStyle(.blue)
                    .opacity(0.4)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.9)
            }
            
            ScrollView {
                VStack(spacing: 20){
                    Text("Stock: \((Int(stock)))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Slider(
                        value: $stock,
                        in: 0...100,
                        step: 1
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    
                    Text("Medicine")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(radius: 3)
                        .frame(height: 160)
                        .overlay(
                            Picker("Medicine", selection: $nameInAisleMEdicine) {
                                ForEach(getOptionMedical()) { name in
                                    Text(name.displayName)
                                }
                            }
                                .pickerStyle(.wheel)
                                .frame(height: 150))
                    Button {
                        
                        Task{
                            try? await medicineStockViewModel.insertMedicineToList(user: identity, name: nameInAisleMEdicine, stock: (Int(stock)), aisle: nameInAisle) // Remplacez par l'utilisateur actuel
                        }
                        if medicineStockViewModel.messageEror != nil {
                            dismiss()
                        }
                        
                    } label: {
                        Text("Validate")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .padding(.top, 10)
                    }
                    
                    if let message = medicineStockViewModel.messageEror {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.headline)
                    }
                    
                }
                .padding()
            }
        }
    }
    
    func getOptionMedical() -> [TypeOF] {
        switch  nameInAisle {
        case "Analgesics and Anti-inflammatory drugs":
            return  [.TypeOne(.Centrally),.TypeOne(.NonSteroidal),.TypeOne(.Peripherally),.TypeOne(.Steroidal)]
        case "Antibiotics and Antibacterials":
            return [.TypeTwo(.Aminoglycosides),.TypeTwo(.Antibiotics),.TypeTwo(.Beta),.TypeTwo(.Cyclic),.TypeTwo(.Macrolides),.TypeTwo(.Tetracyclines),.TypeTwo(.casePhenicols),.TypeTwo(.antibacterials),.TypeTwo(.Tetracyclines),.TypeTwo(.Sulfonamides),.TypeTwo(.Quinolones),.TypeTwo(.Nitroimidazole),.TypeTwo(.Miscellaneous),.TypeTwo(.antibacterials)]
        case "Antituberculosis and Antileprosy drugs" :
            return [.TypeThree(.Antituberculosis),.TypeThree(.Topical)]
        case "Dermatology" :
            return  [.TypeFour(.Anti),.TypeFour(.Antileprosy),.TypeFour(.dermatology)]
        case "Oncology" :
            return [.TypeFive(.Alkylating),.TypeFive(.Antimetabolites),.TypeFive(.Intercalating),.TypeFive(.Tubulin)]
        default:
            return []
        }
    }
    
}

#Preview {
    AddMedicineView(nameInAisle: "Onocology")
}
