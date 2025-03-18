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
            Color.brown.ignoresSafeArea()
            VStack {
                Text("Await")
            }
        }
    }
}

#Preview {
    LoadingView()
}
