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
    @State var search : String = ""
    
    var filter : [String] {
        let medicine = medicineStockViewModel.medicineListed?.medicaments.keys.sorted() ?? []
        return search.isEmpty  ? medicine : medicine.filter{$0.localizedStandardContains(search)}
    }

    var body: some View {
        VStack {
            List {
                Picker("Aisles", selection: $nameInAisle) {
                    ForEach(filter,id: \.self) { aisle in
                       Text(aisle)
                    }
                }
                .pickerStyle(.inline)
            }
        }
        .searchable(text: $search)
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
