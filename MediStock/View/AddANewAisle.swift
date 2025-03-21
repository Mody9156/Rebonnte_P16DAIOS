//
//  AddANewAisle.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import SwiftUI

struct AddANewAisle: View {
    @State var stock : Double = 0.0
    @State private var stockSelected : Int = 0
    @State var nameInAisle : String = ""
    @State var nameInAisleMedicine : String = ""
    @Environment(\.dismiss) var dismiss
    @State var isEditing : Bool = false
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false
    @State private var isLoading = false
    @State private var textfieldStock : String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20){
                    
                    Text("Add a New Aisle")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    List{
                    Section {
                        NavigationLink(nameInAisle.isEmpty ? "Chose Medicine" : nameInAisle) {
                            NewAislesView(nameInAisle: $nameInAisle)
                        }
                        
                    } header : { Text("Aisle")}
                    
                    Section {
                        HStack {
                            UpdateStock(nameIcone: "minus", stock: $stock)
                            TextField("Enter your score", value: $stock, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .onChange(of: stock) { newValue in
                                    stock = min(max(0,newValue),100)
                                }
                            
                            UpdateStock(nameIcone: "plus", stock: $stock)
                        }
                        
                    } header : {Text("Stock")}
                    
                    Section{
                        NavigationLink(nameInAisleMedicine.isEmpty ? "Chose Medicine" : nameInAisleMedicine ) {
                            NewMedicineView(nameInAisle: $nameInAisle, nameInAisleMEdicine: $nameInAisleMedicine)
                        }
                    } header : {Text("Medicine")}
                }
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGray6))
                    
                    Button {
                        isLoading = true
                        Task{
                            try? await medicineStockViewModel.insertAisle(name: nameInAisleMedicine, stock: (Int(stock)), aisle: nameInAisle)
                            if medicineStockViewModel.messageEror == nil {
                                dismiss()
                            }
                            
                            isLoading = false
                        }
                        
                    } label: {
                        
                        if isLoading {
                            ProgressView()
                                .frame(width: 200,height: 40)
                        }else{
                            Text("Validate")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 40)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .padding(.top, 10)
                        }
                    }
                    
                    if let message = medicineStockViewModel.messageEror {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.headline)
                            .padding()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    AddANewAisle()
}

struct UpdateStock: View {
    var nameIcone : String
    @Binding var stock : Double
    
    var body: some View {
        
        VStack {
            Button {
                withAnimation {
                    if nameIcone == "plus" && stock < 100{
                        stock += 1
                    }else if nameIcone == "minus" && stock > 0{
                        stock -= 1
                    }
                }
                
            } label: {
                Image(systemName: nameIcone)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding()
                    .background(nameIcone == "plus" ? Color.gray.opacity(0.3): Color.red.opacity(0.3))
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .frame(width: 50,height: 50)
        }
    }
}
