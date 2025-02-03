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
            LinearGradient(gradient: Gradient(colors: [.blue, Color("BackgroundColor")]), startPoint: .top, endPoint: .bottom)
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
                                
                                TextForShowDetails(user: entry.user)
                                    .accessibilityLabel("Performed by: \(user)")
                                
                                Text("Date: \(entry.timestamp.formatted())")
                                    .font(.subheadline)
                                    .accessibilityLabel("Date: \(entry.timestamp.formatted())")
                                
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
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(filterMedicine: [HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now),
                                     HistoryEntry(medicineId: "48f949df", user: "James@gmail.com", action: "Update", details: "change stock with new values", timestamp: Date.now)])
    }
}

struct TextForShowDetails: View {
    var user : String
    
    var body: some View {
        HStack {
            Text("User:")
                .fontWeight(.bold)
            Text(user)
                .font(.subheadline)
        }
    }
}
