//
//  HistoryView.swift
//  pack
//
//  Created by KEITA on 03/02/2025.
//

import SwiftUI

struct HistoryView: View {
    var filterMedicine : [HistoryEntry]
    var stock : Int
    
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
                                    
                                    Text("Stock change: \(stock > 0 ? "Added +" : "Removed ")\(abs(stock)) units")
                                        .font(.subheadline)
                                        .foregroundStyle(stock > 0 ? .green : .red)

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
    }
}

#Preview{
    HistoryView(filterMedicine: [
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now)
        
    ], stock: 55)
}

struct TextForShowDetails: View {
    var value : String
    var text : String
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.bold)
            Text(value)
                .font(.subheadline)
        }
    }
}
