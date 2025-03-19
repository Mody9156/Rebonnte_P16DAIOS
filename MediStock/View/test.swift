//
//  test.swift
//  pack
//
//  Created by Modibo on 19/03/2025.
//

import SwiftUI

struct test: View {
    @ObservedObject var medicineStockViewModel : MedicineStockViewModel
    @State private var nameInAisle : String = ""
    var body: some View {
        VStack {
            Text("Slide 1 ")
            Picker("picker number : 1", selection: $nameInAisle) {
                ForEach(medicineStockViewModel.medicineListed,id: \.self){ index in
                    Text("Medicaments : \(index.name)")
                }
            }
        }
    }
}

#Preview {
    test(medicineStockViewModel: MedicineStockViewModel())
}
