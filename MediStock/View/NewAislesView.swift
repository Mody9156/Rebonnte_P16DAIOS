//
//  NewAislesView.swift
//  pack
//
//  Created by Modibo on 20/03/2025.
//

import SwiftUI

struct NewAislesView: View {
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @Binding var nameInAisle: String
    
    var body: some View {
        VStack {
            Picker("Aisles", selection: $nameInAisle) {
                ForEach(medicineStockViewModel.medicineListed?.medicaments.keys.sorted() ?? [],id: \.self) { aisle in
                    Text(aisle)
                }
            }
            .pickerStyle(.inline)
        }
    }
}

#Preview {
    struct NEwPreviewWrapper : View {
        @State var nameInAisle : String = ""
        @State var nameInAisleMEdicine : String = ""
        var body: some View {
            NewAislesView(nameInAisle: $nameInAisle)
        }
    }
    return NEwPreviewWrapper()
    
}
