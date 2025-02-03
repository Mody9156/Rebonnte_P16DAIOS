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
        ScrollView {
            VStack {
                ForEach(filterMedicine) { entry in
                    HStack {
                        VStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.blue)
                            Divider()
                                .foregroundColor(.blue)
                                .frame(width:4)
                        }
                        
                        VStack(alignment: .leading,spacing: 5) {
                            Text(entry.action)
                                .font(.headline)
                                .accessibilityLabel("Action: \(entry.action)")
                            
                            HStack {
                                Text("User: \(entry.user)")
                                    .font(.subheadline)
                                .accessibilityLabel("Performed by: \(entry.user)")
                                Text("Date: \(entry.timestamp.formatted())")
                                    .font(.subheadline)
                                    .accessibilityLabel("Date: \(entry.timestamp.formatted())")
                            }
                            
                            
                            Text("Details: \(entry.details)")
                                .font(.subheadline)
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(filterMedicine: [HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
        HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now)])
    }
}
