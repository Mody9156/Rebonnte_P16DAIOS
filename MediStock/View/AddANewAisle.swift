//
//  AddANewAisle.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import SwiftUI

struct AddANewAisle: View {
    @State private var iterateAisles : [String] = ["Analgesics and Anti-inflammatory drugs"]
    var body: some View {
        Text("Hello, World!")
        Picker("", selection: $iterateAisles) {
            
        }
    }
}

#Preview {
    AddANewAisle()
}
