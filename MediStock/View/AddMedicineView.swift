//
//  AddMedicineView.swift
//  pack
//
//  Created by Modibo on 14/03/2025.
//

import SwiftUI

struct AddMedicineView: View {
    @State private var stock : Double = 0.0
    @State private var stockSelected : Int = 0
    @State  var nameInAisle : String
    @State private var nameInAisleMEdicine : String = ""
    @Environment(\.dismiss) var dismiss
    @State var isEditing : Bool = false
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("email") var identity : String = "email"
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false

    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.4)
            
            ScrollView {
                VStack(spacing: 20){
                    Text("Stock: \((Int(stock)))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                    
                    Slider(
                        value: $stock,
                        in: 0...500,
                        step: 1
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("500")
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
                                ForEach(medicineStockViewModel.medicineListed?.medicaments[nameInAisle] ?? [],id: \.self) { name in
                                    Text(name)
                                }
                            }
                                .pickerStyle(.wheel)
                                .frame(height: 150))
                    Button {
                        Task{
                            try? await medicineStockViewModel.insertMedicineToList(user: identity, name: nameInAisleMEdicine, stock: (Int(stock)), aisle: nameInAisle, stockValue: Int(stock))
                            if medicineStockViewModel.messageEror == nil {
                                dismiss()
                            }
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
    }

    
}

#Preview {
    AddMedicineView(nameInAisle: "Onocology")
}
