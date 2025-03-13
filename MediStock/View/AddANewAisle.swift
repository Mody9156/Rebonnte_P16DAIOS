//
//  AddANewAisle.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import SwiftUI

enum SelectAisleList: String, CaseIterable, Identifiable {
    
    case Analgesics = "Analgesics and Anti-inflammatory drugs"
    case Antibiotics = "Antibiotics and Antibacterials"
    case Antituberculosi = "Antituberculosis drugs"
    
    var id: String  { self.rawValue }
}

enum SelectNameOfMedicineList: String, CaseIterable, Identifiable {
    
    case Peripherally = "Peripherally acting analgesics"
    case Centrally = "Centrally acting analgesics"
    case NonSteroidal = "Non-Steroidal Anti-Inflammatory Drugs (NSAIDs)"
    case Steroidal = "Steroidal Anti-Inflammatory Drugs (Corticosteroids)"
    
    var id: String  { self.rawValue }
}

enum SelectNameOfMedicineListTwo: String, CaseIterable, Identifiable {
    
    case Beta = "Beta-lactams"
    case Aminoglycosides = "Aminoglycosides"
    case Macrolides = "Macrolides and related compounds"
    case Antibiotics = "Antibiotics with retained antistaphylococcal activity"
    case Tetracyclines = "Tetracyclines (Cyclines)"
    case casePhenicols = "casePhenicols"
    case Cyclic = "Cyclic polypeptides (Polymyxins)"
    case Sulfonamides = "Sulfonamides and Diaminopyrimidines"
    case Quinolones = "Quinolones"
    case Nitroimidazole = "Nitroimidazole derivatives"
    case Miscellaneous = "Miscellaneous antibiotics"
    case antibacterials =  "antibacterials"
    
    var id: String  { self.rawValue }
}

struct AddANewAisle: View {
    @State private var iterate : SelectAisleList = SelectAisleList.allCases.first!
    @State private var stock : [Int] = Array(0...100)
    @State private var stockSelected : Int = 0
    @State private var selectNameOfMedicineList : SelectNameOfMedicineList = SelectNameOfMedicineList.allCases.first!
    @State private var nameInAisle : String = ""
    @State private var selectNameOfMedicineListTwo : SelectNameOfMedicineListTwo = .allCases.first!
    @State private var nameInAisleMEdicine : String = ""
    @Environment(\.dismiss) var dismiss
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
            
            ScrollView {
                VStack {
                    
                    Text("Selected Aisle: \(nameInAisle)")
                    Text("Selected Medication: \(nameInAisleMEdicine)")
                    Text("Stock : \(stockSelected)")
                    
                    Text("Aisle")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Picker("Aisles", selection: $nameInAisle) {
                        ForEach(SelectAisleList.allCases) { aisle in
                            Text(aisle.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Text("Stock")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Picker("Aisles", selection: $stockSelected) {
                        ForEach(stock,id: \.self){ number in
                            Text("\(number)")
                        }
                    }.pickerStyle(.menu)
                    
                    Text("Medicine")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Picker("Medicine", selection: $nameInAisleMEdicine) {
                        ForEach(SelectNameOfMedicineList.allCases) { name in
                            Text(name.rawValue.capitalized)
                        }
                    }.pickerStyle(.menu)
                    
                    Picker("Medicine", selection: $nameInAisleMEdicine) {
                        ForEach(SelectNameOfMedicineListTwo.allCases) { name in
                            Text(name.rawValue.capitalized)
                        }
                    }.pickerStyle(.menu)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Validate")
                        .foregroundStyle(.white)
                        .background(Color.blue)
                        .frame(height: 40)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    AddANewAisle()
}
