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
    
    
    func delete(medicines: [Medicine], at offsets: IndexSet) async throws {
        do{
          try await medicineService.delete(medicines: medicines, at: offsets)
            
        } catch{
            throw MedicineError.invalidDelete
        }
    }
    
    private func addHistory(action: String, user: String, medicineId: String, details: String) {
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details)
        do {
            try db.collection("history").document(history.id ?? UUID().uuidString).setData(from: history)
        } catch let error {
            print("Error adding history: \(error)")
        }
    }
    
    func updateMedicine(_ medicine: Medicine, user: String) async throws {
        do{
           let medicine = try await medicineService.updateMedicine(medicine, user: user)
            for medicines in medicine {
                addHistory(action: "Updated \(medicines.name)", user: self.identity, medicineId: medicines.id ?? "Unknow", details: "Updated medicine details")
            }
        }catch{
            throw MedicineError.invalidMedicine
        }
    }

    func updateStock(_ medicine: Medicine, by amount: Int, user: String) {
       let medicine = medicineService.updateStock(medicine, by: amount, user: user)
       
        for medicines in medicine {
            let newStock = medicines.stock + amount
            self.addHistory(action: "\(amount > 0 ? "Increased" : "Decreased") stock of \(medicines.name) by \(amount)", user: self.identity, medicineId: medicines.id ?? "Unknow", details: "Stock changed from \(medicines.stock - amount) to \(newStock)")
        }
    }
    
    func fetchHistory(for medicine: Medicine, completion: @escaping([HistoryEntry])->Void) {
        medicineService.fetchHistory(for: medicine) { historyEntry in
            completion(historyEntry)
        }
    }
    //Try here 
    func trieByName(completion:@escaping([Medicine]) ->Void)  {
        medicineService.trieByName { medicine in
            completion(medicine)
        }
    }
    
    func trieByStock(completion:@escaping([Medicine]) ->Void){
        medicineService.trieByStock { medicine in
            completion(medicine)
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
