//
//  LoadingView.swift
//  pack
//
//  Created by Modibo on 18/03/2025.
//

import SwiftUI

struct LoadingView: View {
    @State var selectedAutoConnection: Bool = UserDefaults.standard.bool(forKey: "autoLogin")
    @State private var loeadView : Bool = false
    var body: some View {
        ZStack {
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
            }
        }
    }
}

#Preview {
    LoadingView()
}
