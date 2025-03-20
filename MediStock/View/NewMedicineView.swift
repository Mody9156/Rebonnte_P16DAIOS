//
//  NewMedicineView.swift
//  pack
//
//  Created by Modibo on 20/03/2025.
//

import SwiftUI

struct NewMedicineView: View {
    @Binding  var nameInAisle : String 

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var nameInAisle : String = "Test"
        var body: some View {
            NewMedicineView(nameInAisle: $nameInAisle)
        }
    }
    PreviewWrapper()
}
