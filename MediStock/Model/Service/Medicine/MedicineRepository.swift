//
//  MedicineRepository.swift
//  pack
//  pack
//
//  Created by KEITA on 09/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

class MedicineRepository: ObservableObject {
    private var db : Firestore
    @Published var medicines: [Medicine]
    @Published var historyEntry: [HistoryEntry]
    @AppStorage("email") var identity : String = "email"
    private var medicineService: MedicineProtocol
    
    init(medicines: [Medicine] = [], historyEntry: [HistoryEntry] = [], db : Firestore = Firestore.firestore(),medicineService: MedicineProtocol = MedicineService()){
        self.medicines = medicines
        self.historyEntry = historyEntry
        self.db = db
        self.medicineService = medicineService
    }
    
    func fetchMedicines(completion:@escaping([Medicine]) -> Void) {
        medicineService.fetchMedicines { medicine in
            if medicine.isEmpty {
                print("\(MedicineError.invalidMedicine)")
            }else{
                completion(medicine)
            }
        }
    }
    
    @MainActor
    func fetchAisles(completion:@escaping( [String])->Void) {
        medicineService.fetchAisles { aisles in
            if aisles.isEmpty {
                print("\(MedicineError.invalidAisles)")
            }else{
                completion(aisles)
            }
        }
    }
    
    func setData(user: String) async throws {
        do{
            let medicine = try await medicineService.setData(user: user)
            for medicines in medicine {
                addHistory(action: "Added \(medicines.name)", user: self.identity, medicineId: medicines.id ?? "Unknow", details: "Added new medicine")
            }
        }catch{
            throw MedicineError.invalidSetData
        }
    }
    
    @MainActor
    func setDataToList(user: String, aisle: String) async throws {
        do{
            let medicine = try await medicineService.setDataToList(user: user, aisle: aisle)
            for medicines in medicine {
                addHistory(action: "Added \(medicines.name)", user: user, medicineId: medicines.id ?? "Unknow", details: "Added new medicine")
            }
        }catch{
            throw MedicineError.invalidSetData
        }
    }
    
    
    func delete(medicines: [Medicine], at offsets: IndexSet) {
//        offsets.map { medicines[$0] }.forEach { medicine in
//            if let id = medicine.id {
//                db.collection("medicines").document(id).delete { error in
//                    if let error = error {
//                        print("Error removing document: \(error)")
//                    }
//                }
//            }
//        }
    }
    
    private func addHistory(action: String, user: String, medicineId: String, details: String) {
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details)
        do {
            try db.collection("history").document(history.id ?? UUID().uuidString).setData(from: history)
        } catch let error {
            print("Error adding history: \(error)")
        }
    }
    
    func updateMedicine(_ medicine: Medicine, user: String){
        
        guard let id = medicine.id else { return }
        do {
            try db.collection("medicines").document(id).setData(from: medicine)
            addHistory(action: "Updated \(medicine.name)", user: self.identity, medicineId: medicine.id ?? "Unknow", details: "Updated medicine details")
            
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
                self.addHistory(action: "\(amount > 0 ? "Increased" : "Decreased") stock of \(medicine.name) by \(amount)", user: self.identity, medicineId: medicine.id ?? "Unknow", details: "Stock changed from \(medicine.stock - amount) to \(newStock)")
            }
        }
    }
    
    func fetchHistory(for medicine: Medicine, completion: @escaping([HistoryEntry])->Void) {
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
    
    func trieByName(completion:@escaping([Medicine]) ->Void)  {
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
    
    func trieByStock(completion:@escaping([Medicine]) ->Void){
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
    
    func getAllElements(completion:@escaping([Medicine]) -> Void) {
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
    //
    //    func checkIfCollectionIsEmpty(collectionName: String, completion: @escaping (Bool) -> Void) {
    //        let db = Firestore.firestore()
    //        let collectionRef = db.collection(collectionName)
    //
    //        collectionRef.getDocuments { (querySnapshot, error) in
    //            if let error = error {
    //                print("Erreur lors de la vérification : \(error)")
    //                completion(false)
    //                return
    //            }
    //
    //            if let documents = querySnapshot?.documents, documents.isEmpty {
    //                print("La collection \(collectionName) est vide.")
    //                completion(true)
    //            } else {
    //                print("La collection \(collectionName) contient encore des documents.")
    //                completion(false)
    //            }
    //        }
    //    }
    
}


enum MedicineError: LocalizedError {
    case invalidDelete
    case invalidMedicine
    case invalidAisles
    case invalidSetData
    
    var errorDescription: String? {
        switch self {
        case .invalidDelete:
            return "Impossible de se supprimer. Vérifiez vos informations et réessayez."
        case .invalidMedicine:
            return "Impossible de récupérer les données du tableau"
        case .invalidAisles:
            return "Impossible de récupérer les aisles du tableau"
        case .invalidSetData:
            return "Impossible d'ajouter un nouvelle element au tableau"
        }
    }
}
