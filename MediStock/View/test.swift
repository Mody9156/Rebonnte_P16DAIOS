//
//  test.swift
//  pack
//
//  Created by Modibo on 19/03/2025.
//

import SwiftUI

struct test: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @State private var nameInAisle : String = ""
    @State private var selectionCategorie : String = ""

    var body: some View {
        VStack {
            Text("Slide 1 \(nameInAisle) ")
            
            Picker("picker number : 1", selection: $selectionCategorie) {
                ForEach(medicineStockViewModel.medicineListed?.medicaments.keys.sorted() ?? [], id: \.self) { index in
                    
                    Text("Asaisle : \(index)")
                }
            }
            .pickerStyle(.wheel)
            
            Picker("picker number : 1", selection: $nameInAisle) {
                ForEach(medicineStockViewModel.medicineListed?.medicaments[selectionCategorie] ?? [], id: \.self) { index in
                    
                    Text("Asaisle : \(index)")
                }
            }
            .pickerStyle(.wheel)
            
        }
        .onAppear{
            if let selectionfirst = medicineStockViewModel.medicineListed?.medicaments.keys.sorted().first {
                selectionCategorie = selectionfirst
            }
        }
    }
}

#Preview {
    test()
}
