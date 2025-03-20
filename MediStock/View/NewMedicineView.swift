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
    
    var body: some View {
        
        VStack {
            Text("Medicine")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
        }
        
        List {
            Picker("Medicine", selection: $nameInAisleMEdicine) {
                ForEach(medicineStockViewModel.medicineListed?.medicaments[nameInAisle] ?? [],id:\.self) { name in
                    Text(name)
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
            NewMedicineView(nameInAisle: $nameInAisle, nameInAisleMEdicine: $nameInAisleMEdicine)
        }
    }
    return NEwPreviewWrapper()

}
