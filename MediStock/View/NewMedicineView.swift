//
//  NewMedicineView.swift
//  pack
//
//  Created by Modibo on 20/03/2025.
//

import SwiftUI

struct NewMedicineView: View {
    @Binding  var nameInAisle : String 
    @Binding  var nameInAisleMEdicine : String
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()

    var body: some View {
        
        VStack {
            Text("Medicine")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
        }
        RoundedRectangle(cornerRadius: 10)
            .fill(.white)
            .shadow(radius: 3)
            .frame(height: 160)
            .overlay(
                Picker("Medicine", selection: $nameInAisleMEdicine) {
                    ForEach(medicineStockViewModel.medicineListed?.medicaments[nameInAisle] ?? [],id:\.self) { name in
                        Text(name)
                    }
                }
                    .pickerStyle(.wheel)
                    .frame(height: 150))
    }
}
//
//#Preview {
//    NewMedicineView(nameInAisle: $nameInAisle, nameInAisleMEdicine: $medicineStockViewModel)
//
//}
