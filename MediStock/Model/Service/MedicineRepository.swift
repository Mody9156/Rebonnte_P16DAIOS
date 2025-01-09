//
//  MedicineRepository.swift
//  pack
//
//  Created by KEITA on 09/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class MedicineRepository: ObservableObject {
    private var db = Firestore.firestore()
    @Published var medicines: [Medicine]
    @Published var aisles: [String]
    
    init(medicines: [Medicine], aisles: [String]) {
        self.medicines = medicines
        self.aisles = aisles
    }
    
    func fetchMedicines() {
        db.collection("medicines").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.medicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
            }
        }
    }
    
    func fetchAisles() {
        db.collection("medicines").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let allMedicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
                self.aisles = Array(Set(allMedicines.map { $0.aisle })).sorted()
            }
        }
    }

}
