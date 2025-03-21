//
//  AddANewAisle.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import SwiftUI

struct AddANewAisle: View {
    @State var stock: Double = 0.0
    @State var nameInAisle: String = ""
    @State var nameInAisleMedicine: String = ""
    @Environment(\.dismiss) var dismiss
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("toggleDarkMode") private var toggleDarkMode: Bool = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Aisle")
                            .font(.title2)
                            .font(.headline)
                            .foregroundStyle(Color("TextColor"))
                            .accessibilityLabel("Stock Label")
                        
                        NavigationLink {
                            NewAislesView(nameInAisle: $nameInAisle)
                        } label: {
                            HStack {
                                Text(nameInAisle.isEmpty ? "Choose Aisle" : nameInAisle)
                                    .foregroundStyle(.gray)
                                
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
                    .padding(.horizontal)
                    
                    Divider()
                    
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
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Medicine")
                            .font(.title2)
                            .font(.headline)
                            .foregroundStyle(Color("TextColor"))
                            .accessibilityLabel("Stock Label")
                        
                        NavigationLink {
                            NewMedicineView(nameInAisle: $nameInAisle, nameInAisleMEdicine: $nameInAisleMedicine)
                        } label: {
                            HStack {
                                Text(nameInAisleMedicine.isEmpty ? "Choose Medicine" : nameInAisleMedicine)
                                    .foregroundStyle(.gray)
                                
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
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        isLoading = true
                        Task {
                            try? await medicineStockViewModel.insertAisle(
                                name: nameInAisleMedicine,
                                stock: Int(stock),
                                aisle: nameInAisle
                            )
                            if medicineStockViewModel.messageEror == nil {
                                dismiss()
                            }
                            isLoading = false
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .frame(width: 200, height: 40)
                        } else {
                            Text("Validate")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 40)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                    }
                    .padding(.top, 10)
                    
                    if let message = medicineStockViewModel.messageEror {
                        Text(message)
                            .foregroundColor(.red)
                            .font(.headline)
                            .padding()
                    }
                    
                    Spacer()
                }
                .navigationTitle("New Aisle")
                .padding()
            }
        }
    }
}

#Preview {
    AddANewAisle()
}

struct UpdateStock: View {
    var nameIcone: String
    @Binding var stock: Double
    
    var body: some View {
        Button {
            withAnimation {
                if nameIcone == "plus", stock < 500 {
                    stock += 1
                } else if nameIcone == "minus", stock > 0 {
                    stock -= 1
                }
            }
        } label: {
            Image(systemName: nameIcone)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .shadow(radius: 2)
        }
        .frame(width: 50, height: 50)
    }
}
