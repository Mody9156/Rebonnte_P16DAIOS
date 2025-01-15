//
//  Profile.swift
//  pack
//
//  Created by KEITA on 15/01/2025.
//

import SwiftUI

struct Profile: View {
    @StateObject var medicineStockViewModel : MedicineStockViewModel
    var body: some View {
        VStack {
            Text("Profile")
            Button("Sign Out") {
                <#code#>
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
