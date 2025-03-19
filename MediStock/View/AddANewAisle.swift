//
//  AddANewAisle.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import SwiftUI

struct AddANewAisle: View {
    @State private var stock : Double = 0.0
    @State private var stockSelected : Int = 0
    @State private var nameInAisle : String = ""
    @State private var nameInAisleMEdicine : String = ""
    @Environment(\.dismiss) var dismiss
    @State var isEditing : Bool = false
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false

    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.4)
            
            ScrollView {
                VStack(spacing: 20){
                    Text("Aisle")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(radius: 3)
                        .frame(height: 160)
                        .overlay(
                            Picker("Aisles", selection: $nameInAisle) {
                                ForEach(medicineStockViewModel.medicineListed?.medicaments.keys.sorted() ?? [],id: \.self) { aisle in
                                    Text(aisle)
                                }
                            }
                                .pickerStyle(.wheel)
                                .frame(height: 150))
                    
                    Text("Stock: \((Int(stock)))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Slider(
                        value: $stock,
                        in: 0...100,
                        step: 1
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    
                    Text("Medicine")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
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
                    Button {
                        Task{
                            try? await medicineStockViewModel.insertAisle(name: nameInAisleMEdicine, stock: (Int(stock)), aisle: nameInAisle)
                        }
                        
                        if medicineStockViewModel.messageEror != nil {
                            dismiss()
                        }
                        
                    } label: {
                        Text("Validate")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 40)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .padding(.top, 10)
                    }
                    
                    if let message = medicineStockViewModel.messageEror {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.headline)
                    }
                    
                }
                .padding()
            }
        }
        .onAppear{
            if let index = medicineStockViewModel.medicineListed?.medicaments.keys.sorted().first {
                nameInAisle = index
            }
        }
        .preferredColorScheme(toggleDarkMode ? .dark : .light)
    }
}

#Preview {
    AddANewAisle()
}
