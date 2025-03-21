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
    @State var nameInAisle : String = ""
    @State var nameInAisleMedicine : String = ""
    @Environment(\.dismiss) var dismiss
    @State var isEditing : Bool = false
    @ObservedObject var medicineStockViewModel = MedicineStockViewModel()
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20){
                    List {
                        Section {
                            NavigationLink(nameInAisle.isEmpty ? "Chose Medicine" : nameInAisle) {
                                NewAislesView(nameInAisle: $nameInAisle)
                            }
                            
                        } header : { Text("Aisle")}
                        
                        Section {
                            
//                            HStack {
//                                Text("\(Int(stock))")
//                                Spacer()
//                                Slider(
//                                    value: $stock,
//                                    in: 0...100,
//                                    step: 1
//                                )
//                                .frame(width: 150)
//                            }
                            ExtractedView()
                            
                        } header : {Text("Stock")}
                        
                        Section{
                            NavigationLink(nameInAisleMedicine.isEmpty ? "Chose Medicine" : nameInAisleMedicine ) {
                                NewMedicineView(nameInAisle: $nameInAisle, nameInAisleMEdicine: $nameInAisleMedicine)
                            }
                        } header : {Text("Medicine")}
                    }
                    
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

struct ExtractedView: View {
    var body: some View {
        Button("") {
            
        }
    }
}
