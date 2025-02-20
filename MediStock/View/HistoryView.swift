//
//  HistoryView.swift
//  pack
//
//  Created by KEITA on 03/02/2025.
//

import SwiftUI

struct HistoryView: View {
    var filterMedicine : [HistoryEntry]
   
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue,Color("BackgroundColor")]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            ScrollView {
                VStack (alignment:.leading){
                    ForEach(filterMedicine) { entry in
                        HStack {
                            VStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                                HStack {
                                    Divider()
                                        .frame(width:4)
                                        .overlay(.white)
                                }
                            }
                            
                            VStack(alignment: .leading,spacing: 5) {
                                Text(entry.action)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .accessibilityLabel("Action: \(entry.action)")
                                
                                TextForShowDetails(value: entry.user,text: "User:")
                                    .accessibilityLabel("Performed by: \(entry.user)")
                                TextForShowDetails(value: entry.timestamp.formatted(),text: "Date:")
                                    .accessibilityLabel("Date: \(entry.timestamp.formatted())")
                                
                                TextForShowDetails(value: entry.details,text: "Details")
                                    .accessibilityLabel("Details: \(entry.details)")
                                    
                            }
                            .padding()
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            .accessibilityElement(children: .combine)
                            .accessibilityHint("Details of this history entry.")
                            
                        }
                    }
                }
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
                                
    ])
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
