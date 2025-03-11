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
    
    func setDataToAisle() async throws -> [Medicine] {
            
        let collection =  try await db.collection("medicines").getDocuments()
        let snapshot = Set(collection.documents.compactMap({ query in
            query.data()["aisle"] as? String
        }))
        
        let allAisles = Set((0...10).map{"Aisle \($0)"})
        let aisles = allAisles.subtracting(snapshot)
        
        guard let getAisles = aisles.randomElement() else {
            throw NSError(domain: "com.example.medicine", code: 1, userInfo: [NSLocalizedDescriptionKey: "Toutes les allées sont déjà assignées."])
        }
        
            let medicine = Medicine(name: "Medicine \(Int.random(in: 1...100))", stock: Int.random(in: 1...100), aisle: "Aisle \(getAisles)")
        
        do {
                try db.collection("medicines").document(medicine.id ?? UUID().uuidString).setData(from: medicine)
                print("Graduation vous venez d'ajouter: \(medicine)")
            
            
        } catch let error {
            print("Error adding document: \(error)")
        }
        return [medicine]
    }
    
    
    func setDataToList(user: String, aisle: String) async throws -> [Medicine] {
        let medicine = Medicine(name: "Medicine \(Int.random(in: 1...100))", stock: Int.random(in: 1...100), aisle: aisle)
        do {
            try db.collection("medicines").document(medicine.id ?? UUID().uuidString).setData(from: medicine)
            print("Ajouté : \(medicine)")
            self.medicines.append(medicine) // Ajoute localement pour éviter un délai
            
        } catch {
            print("Erreur : \(error)")
        }
        return [medicine]
    }
    
  
    func delete(medicines: [Medicine], at offsets: IndexSet) async throws {
        offsets.map { medicines[$0] }.forEach { medicine in
            if let id = medicine.id {
                print("Voici votre id: \(id)")
                db.collection("medicines").document(id).delete { error in
                    
                    if let error = error {
                        print("Error removing document: \(error)")
                    }
                }
            }
        }
    }
    //vérifier l'erreur concernant la suppréssion des 💊
    func deleteAisle(aisles:[String], at offsets: IndexSet) async throws -> [String] {
        var updateAisle = aisles
        
        let medicineDelete = offsets.map { updateAisle[$0]}
        print("medicineDelete :\(medicineDelete)")
        for aisles in medicineDelete {
            print("Vous allez supprimer l'id : \(aisles)")
            let query =  try await db.collection("medicines")
                .whereField("aisle", isEqualTo: aisles)
                .getDocuments()
            
            if query.documents.isEmpty {
                print("Aisle sélectionnée n'existe pas")
            }
            for id in query.documents {
                let documentId = id.documentID
                
                do{
                    try await db.collection("medicines").document(documentId).delete()

                    print("✅ Document \(documentId) supprimé avec succès")
                } catch {
                    print("❌ Erreur Firebase : \(error.localizedDescription)")
                }
            }
            updateAisle.removeAll {  medicineDelete.contains($0)}
        }
        return updateAisle
    }
    
    func updateMedicine(_ medicine: Medicine, user: String) async throws -> [Medicine] {
        guard let id = medicine.id else { return [medicine]}
        do {
            try db.collection("medicines").document(id).setData(from: medicine)
        } catch let error {
            print("Error updating document: \(error)")
        }
        return [medicine]
    }
    
    func updateStock(_ medicine: Medicine, by amount: Int, user: String) -> [Medicine] {
        guard let id = medicine.id else { return [medicine]}
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
        return [medicine]
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
