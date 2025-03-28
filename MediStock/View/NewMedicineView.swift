//
//  NewMedicineView.swift
//  pack
//
//  Created by Modibo on 20/03/2025.
//

import SwiftUI

struct NewMedicineView: View {
    @Binding var nameInAisle : String
    @Binding var nameInAisleMEdicine : String
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @State var search : String = ""
    
    var body: some View {
        VStack {
            if nameInAisle.isEmpty {
                Text("Aucun médicament sélectionné. Veuillez choisir une allée.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            List {
                Picker("Medicine", selection: $nameInAisleMEdicine) {
                    ForEach(filter.sorted(),id:\.self) { name in
                        Text(name)
                    }
                }
                .pickerStyle(.inline)
            }

        }
        .navigationTitle("Medicine")
        .searchable(text: $search)
  }
    
    var filter : [String] {
        if search.isEmpty {
            return medicineStockViewModel.medicineListed?.medicaments[nameInAisle] ?? []
        }else{
            return medicineStockViewModel.medicineListed?.medicaments[nameInAisle]?.filter{$0.contains(search)} ?? []
        }
    }
}

#Preview {
    struct NEwPreviewWrapper : View {
        @State var nameInAisle : String = ""
        @State var nameInAisleMEdicine : String = ""
        var body: some View {
            NewMedicineView(nameInAisle: $nameInAisle, nameInAisleMEdicine: $nameInAisleMEdicine)
        }
    }
    return NEwPreviewWrapper()

}
