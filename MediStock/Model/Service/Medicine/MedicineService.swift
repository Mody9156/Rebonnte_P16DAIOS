//
//  MedicineService.swift
//  pack
//
//  Created by KEITA on 31/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class MedicineService: MedicineProtocol, ObservableObject{
    @Published var medicines: [Medicine] = []
    private var db : Firestore = Firestore.firestore()
    
    func fetchMedicines(completion: @escaping ([Medicine]) -> Void) {
        db.collection("medicines").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                let medicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
                completion(medicines)
            }
        }
    }
    
    func fetchAisles(completion: @escaping ([String]) -> Void) {
        db.collection("medicines").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let allMedicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
                let aisles = Array(Set(allMedicines.map { $0.aisle })).sorted()
                completion(aisles)
            }
        }
    }
    
    func setData(user: String) async throws -> [Medicine] {
        let medicine = Medicine(name: "Medicine \(Int.random(in: 1...100))", stock: Int.random(in: 1...100), aisle: "Aisle \(Int.random(in: 1...10))")
        do {
            try db.collection("medicines").document(medicine.id ?? UUID().uuidString).setData(from: medicine)
            print("Graduation vous venez d'ajouter: \(medicine)")
            
        } catch let error {
            print("Error adding document: \(error)")
        }
        return [medicine]
    }
    
    func setDataToList(user: String, aisle: String) async throws {
        let medicine = Medicine(name: "Medicine \(Int.random(in: 1...100))", stock: Int.random(in: 1...100), aisle: aisle)
        do {
            try db.collection("medicines").document(medicine.id ?? UUID().uuidString).setData(from: medicine)
            print("Ajouté : \(medicine)")
            DispatchQueue.main.async {
                self.medicines.append(medicine) // Ajoute localement pour éviter un délai
            }
            
        } catch {
            print("Erreur : \(error)")
        }
    }
    
    func delete(medicines: [Medicine], at offsets: IndexSet) {
        offsets.map { medicines[$0] }.forEach { medicine in
            if let id = medicine.id {
                db.collection("medicines").document(id).delete { error in
                    if let error = error {
                        print("Error removing document: \(error)")
                    }
                }
            }
        }
    }
    
    func updateMedicine(_ medicine: Medicine, user: String) {
        guard let id = medicine.id else { return }
        do {
            try db.collection("medicines").document(id).setData(from: medicine)
        } catch let error {
            print("Error updating document: \(error)")
        }
    }
    
    func updateStock(_ medicine: Medicine, by amount: Int, user: String) {
        guard let id = medicine.id else { return }
        let newStock = medicine.stock + amount
        db.collection("medicines").document(id).updateData([
            "stock": newStock
        ]) { error in
            if let error = error {
                print("Error updating stock: \(error)")
            } else {
                if let index = self.medicines.firstIndex(where: { $0.id == id }) {
                    self.medicines[index].stock = newStock
                }
            }
        }
    }
    
    func fetchHistory(for medicine: Medicine, completion: @escaping ([HistoryEntry]) -> Void) {
        guard let id = medicine.id else {return}
        db.collection("history").whereField("medicineId", isEqualTo: id).order(by: "timestamp", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting history: \(error)")
            } else {
                let history = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: HistoryEntry.self)
                    
                } ?? []
                print("history:\(history)")
                completion(history)
            }
        }
    }
    
    func trieByName(completion: @escaping ([Medicine]) -> Void) {
        db.collection("medicines").order(by: "name", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let medicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
                completion(medicines)
            }
        }
    }
    
    func trieByStock(completion: @escaping ([Medicine]) -> Void) {
        db.collection("medicines").order(by: "stock", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let medicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
                completion(medicines)
            }
        }
    }
    
    func getAllElements(completion: @escaping ([Medicine]) -> Void) {
        db.collection("medicines").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let medicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
                completion(medicines)
            }
        }
    }
}
