//
//  HistoryView.swift
//  pack
//
//  Created by KEITA on 03/02/2025.
//

import SwiftUI

struct HistoryView: View {
    var filterMedicine : [HistoryEntry]
    @AppStorage("toggleDarkMode") private var toggleDarkMode : Bool = false

    var body: some View {
        ZStack {
           
            ScrollView {
                VStack (alignment:.leading){
                    ForEach(filterMedicine) { entry in
                        HStack {
                            VStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(Color("TextColor"))
                                HStack {
                                    Divider()
                                        .frame(width:4)
                                        .overlay(Color("TextColor"))
                                }
                            }
                            
                            VStack(alignment: .leading,spacing: 5) {
                                Text(entry.stock == 0 ? "Changes Applied to Medication" : entry.action)
                                    .foregroundColor(entry.stock == 0 ? .blue : (entry.stock > 0 ? .green : .red) )
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .accessibilityLabel("Action: \(entry.action)")
                                
                                TextForShowDetails(value: entry.user,text: "User:")
                                    .accessibilityLabel("Performed by: \(entry.user)")
                                TextForShowDetails(value: entry.timestamp.formatted(),text: "Date:")
                                    .accessibilityLabel("Date: \(entry.timestamp.formatted())")
                                
                                TextForShowDetails(value:entry.stock == 0 ? "Details Updated" : entry.details,text: "Details")
                                    .accessibilityLabel("Details: \(entry.details)")
                                
                                
                                HStack {
                                    Text("Stock:")
                                        .fontWeight(.bold)
                                    Text("\(entry.stock == 0 ? "Stock unchanged " : (entry.stock > 0 ? "Added +" : "Removed "))\(abs(entry.stock))")
                                        .font(.subheadline)
                                        .foregroundStyle(entry.stock == 0 ? .blue :(entry.stock > 0 ? .green : .red))
                                        .accessibilityLabel("Stock: \(String(entry.stock))")
                                }
                            }
                            .padding()
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            .accessibilityElement(children: .combine)
                            .accessibilityHint("Details of this history entry.")
                            
                        }
                    }
                }
                .padding()
            }
        }
    }
}
//
//#Preview{
//    HistoryView(filterMedicine: [
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 4),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 64),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 94),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 4),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 84),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 74),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 34),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 24),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 14),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 44),
//        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 47)
//        
//    ])
//}
