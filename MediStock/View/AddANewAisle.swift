//
//  AddANewAisle.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import SwiftUI

enum AisleList: String, CaseIterable, Identifiable {
    case Analgesics, Antibiotics, Antibacterials
    var id: Self { self }
}

struct AddANewAisle: View {
    @State private var iterateAisles : [String] = ["Analgesics and Anti-inflammatory drugs","Antibiotics and Antibacterials"]
    @State private var stock : [Int] = Array(0...100)
    @State private var name : [String] = ["Peripherally acting analgesics","Centrally acting analgesics","Antispasmodics","Non-Steroidal Anti-Inflammatory Drugs (NSAIDs)","Steroidal Anti-Inflammatory Drugs (Corticosteroids)"]
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Select Aisles")
                Picker("Aisles", selection: $iterateAisles) {
                    ForEach(iterateAisles,id: \.self) { flavor in
                        Text(flavor)
                    }
                }.pickerStyle(.wheel)
                
                Text("Stock")
                    .padding()
                Picker("Aisles", selection: $stock) {
                    ForEach(stock,id: \.self){ number in
                        Text("\(number)")
                    }
                }.pickerStyle(.inline)
                
                Text("Medicine")
            }
        }
    }
}

#Preview {
    AddANewAisle()
}
