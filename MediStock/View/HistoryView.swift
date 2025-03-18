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
            Color(.gray)
                .ignoresSafeArea()
                .opacity(0.1)
            
            Circle()
                .frame(height: 200)
                .position(x: 1, y: 1)
                .foregroundStyle(.blue)
                .opacity(0.4)
            
            Circle()
                .frame(height: 200)
                .position(x: 400, y: 800)
                .foregroundStyle(.blue)
                .opacity(0.4)
            
            ScrollView {
                VStack (alignment:.leading){
                    ForEach(filterMedicine) { entry in
                        HStack {
                            VStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.blue)
                                HStack {
                                    Divider()
                                        .frame(width:4)
                                        .overlay(.blue)
                                }
                            }
                            
                            VStack(alignment: .leading,spacing: 5) {
                                Text(entry.action)
                                    .foregroundColor(.blue)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .accessibilityLabel("Action: \(entry.action)")
                                
                                TextForShowDetails(value: entry.user,text: "User:")
                                    .accessibilityLabel("Performed by: \(entry.user)")
                                TextForShowDetails(value: entry.timestamp.formatted(),text: "Date:")
                                    .accessibilityLabel("Date: \(entry.timestamp.formatted())")
                                
                                TextForShowDetails(value: entry.details,text: "Details")
                                    .accessibilityLabel("Details: \(entry.details)")
                                
                                
                                HStack {
                                    Text("Stock:")
                                        .fontWeight(.bold)
                                    Text("\(String(entry.stock > 0 ? "Added +" : "Removed "))\(abs(entry.stock))")
                                        .font(.subheadline)
                                        .foregroundStyle(entry.stock > 0 ? .green : .red)
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
                .padding(.top)
            }
        }
        .preferredColorScheme(toggleDarkMode ? .dark : .light)
    }
}

#Preview{
    HistoryView(filterMedicine: [
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 4),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 64),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 94),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 4),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 84),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 74),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 34),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 24),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 14),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 44),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now, stock: 47)
        
    ])
}
