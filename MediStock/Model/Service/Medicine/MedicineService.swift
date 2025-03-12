//
//  MedicineService.swift
//  pack
//
//  Created by KEITA on 31/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

enum ValidationError : Error {
    case setDataThorwError(result:Error)
    case setDataToAisleThrowError(result:Error)
    case setDataToListThrowError(result:Error)
    case deleteThrowError(result:Error)
    case deleteAisleThroughError
    case queryIsNotEmpty
    case updateMedicineThrowError(result:Error)
    case updateStockThrowError(result:Error)
    case fetchHistoryThrowError(result:Error)
    case trieByNameThrowError(result:Error)
    case trieByStockThrowError(result:Error)
    case getAllElementsThrowError(result:Error)
}

class MedicineService: MedicineProtocol, ObservableObject{
    @Published var medicines: [Medicine] = []
    private var db : Firestore = Firestore.firestore()
    
    func fetchMedicines(completion: @escaping ([Medicine]) -> Void) {
        db.collection("medicines").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
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
                completion([])
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
            try db.collection("medicines").document(medicine.id ?? UUID().uuidString).setData(from: medicine)
            
        } catch let error {
          throw  ValidationError.setDataThorwError(result: error)
        }
        return [medicine]
    }
    
    func setDataToAisle() async throws -> [Medicine] {
            
        let collection =  try await db.collection("medicines").getDocuments()
        let snapshot = Set(collection.documents.compactMap({ query in
            query.data()["aisle"] as? String
        }))
        
        let allAisles = Set((1...10).map{"Aisle \($0)"})
        let aisles = allAisles.subtracting(snapshot)
        
        guard let getAisles = aisles.randomElement() else {
            throw NSError(domain: "com.example.medicine", code: 1, userInfo: [NSLocalizedDescriptionKey: "Toutes les allées sont déjà assignées."])
        }
        
            let medicine = Medicine(name: "Medicine \(Int.random(in: 1...100))", stock: Int.random(in: 1...100), aisle: getAisles)
        
        do {
                try db.collection("medicines").document(medicine.id ?? UUID().uuidString).setData(from: medicine)
            
        } catch let error {
            throw ValidationError.setDataToAisleThrowError(result: error)
        }
        return [medicine]
    }
    
    
    func setDataToList(user: String, aisle: String) async throws -> [Medicine] {
        let medicine = Medicine(name: "Medicine \(Int.random(in: 1...100))", stock: Int.random(in: 1...100), aisle: aisle)
        do {
            try db.collection("medicines").document(medicine.id ?? UUID().uuidString).setData(from: medicine)
            self.medicines.append(medicine) // Ajoute localement pour éviter un délai
            
        } catch {
            throw  ValidationError.setDataToListThrowError(result: error)
        }
        return [medicine]
    }
    
  
    func delete(medicines: [Medicine], at offsets: IndexSet) async throws {
        offsets.map { medicines[$0] }.forEach { medicine in
            if let id = medicine.id {
                print("Voici votre id: \(id)")
                db.collection("medicines").document(id).delete { error in
                    
                    if let error = error {
                      let _ =  ValidationError.deleteThrowError(result: error)
                    }
                }
            }
        }
    }
    
    //vérifier l'erreur concernant la suppréssion des 💊
    func deleteAisle(aisles:[String], at offsets: IndexSet) async throws -> [String] {
        var updateAisle = aisles
        let medicineDelete = offsets.map { updateAisle[$0]}
        
        for aisles in medicineDelete {
            let query =  try await db.collection("medicines")
                .whereField("aisle", isEqualTo: aisles)
                .getDocuments()
            
            if query.documents.isEmpty {
              let _ =  ValidationError.queryIsNotEmpty
            }
            
            for id in query.documents {
                let documentId = id.documentID
                
                do{
                    try await db.collection("medicines").document(documentId).delete()
                } catch {
                  throw  ValidationError.deleteAisleThroughError
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
            throw  ValidationError.updateMedicineThrowError(result: error)
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
                let _ = ValidationError.updateStockThrowError(result: error)
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
                let _ = ValidationError.fetchHistoryThrowError(result: error)
            } else {
                let history = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: HistoryEntry.self)
                    
                } ?? []
                completion(history)
            }
        }
    }
    
    func trieByName(completion: @escaping ([Medicine]) -> Void) {
        db.collection("medicines").order(by: "name", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                let _ = ValidationError.trieByNameThrowError(result: error)
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
                let _ = ValidationError.trieByStockThrowError(result: error)
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
                let _ = ValidationError.getAllElementsThrowError(result: error)
            } else {
                let medicines = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Medicine.self)
                } ?? []
                completion(medicines)
            }
        }
    }
}
