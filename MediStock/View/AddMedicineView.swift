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
        NavigationStack {
                    VStack{
                     
                        VStack(alignment: .leading) {
                            
                            Text("Stock")
                                .font(.title2)
                                .font(.headline)
                                .foregroundStyle(Color("TextColor"))
                                .accessibilityLabel("Stock Label")
                            
                           
                            HStack {
                                UpdateStock(nameIcone: "minus", stock: $stock)
                                
                                TextField("Enter stock", value: $stock, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 80)
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .onChange(of: stock) { newValue in
                                        stock = min(max(0, newValue), 500)
                                    }
                                
                                UpdateStock(nameIcone: "plus", stock: $stock)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding()
                        
                        Divider()
                                                
                        VStack(alignment: .leading) {
                            Text("Medicine")
                                .font(.title2)
                                .font(.headline)
                                .foregroundStyle(Color("TextColor"))
                                .accessibilityLabel("Stock Label")
                            
                            NavigationLink {
                                NewMedicineView(nameInAisle: $nameInAisle, nameInAisleMEdicine: $nameInAisleMEdicine)
                            } label: {
                                HStack {
                                    Text(nameInAisleMEdicine.isEmpty ? "Choose Medicine" : nameInAisleMEdicine)
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            
                        }
                        .padding()
                        
                        Spacer()
                        
                        Button {
                            Task{
                                try? await medicineStockViewModel.insertMedicineToList(user: identity, name: nameInAisleMEdicine, stock: (Int(stock)), aisle: nameInAisle, stockValue: Int(stock))
                                if medicineStockViewModel.messageEror == nil {
                                    dismiss()
                                }
                            }
                            
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(height: 45)
                                    .foregroundColor(.blue)
                                    .cornerRadius(15)
                                
                                Text("Validate")
                                    .font(.title3)
                                    .foregroundStyle(Color("RectangleDarkMode"))
                            }
                        }
                        
                        if let message = medicineStockViewModel.messageEror {
                            Text(message)
                                .foregroundStyle(.red)
                                .font(.headline)
                        }
                        
                    }
                    .navigationTitle("New Medicine")
                    .padding()
                
            
        }
    }
}

//#Preview {
//    AddMedicineView(nameInAisle: "Onocology")
//}
