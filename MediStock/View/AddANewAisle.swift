//
//  AddANewAisle.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import SwiftUI

struct AddANewAisle: View {
    @State private var stock : [Int] = Array(0...100)
    @State private var stockSelected : Int = 0
    @State private var nameInAisle : String = ""
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
                    
                    Text("Aisle")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Picker("Aisles", selection: $nameInAisle) {
                        ForEach(SelectedAisles.allCases) { aisle in
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
                        ForEach(getOptionMedical()) { name in
                            Text(name.displayName)
                        }
                    }.pickerStyle(.wheel)
                    
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
    AddANewAisle()
}
