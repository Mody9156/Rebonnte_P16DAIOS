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
                let _ = MedicineError.medicineIsEmpty
            }else{
                completion(medicine)
            }
        }
    }
    
    func fetchAisles(completion:@escaping( [String])->Void) {
        medicineService.fetchAisles { aisles in
            if aisles.isEmpty {
                let _ = MedicineError.aisleIsEmpty
            }else{
                completion(aisles)
            }
        }
    }
    
    func setData(user: String) async throws {
        do{
            let medicine = try await medicineService.setData(user: user)
            for medicines in medicine {
                try? await  addHistory(action: "Added \(medicines.name)", user: self.identity, medicineId: medicines.id ?? "Unknow", details: "Added new medicine")
            }
        }catch{
            throw MedicineError.invalidSetData
        }
    }
    
    func setDataToList(user: String, aisle: String) async throws {
        do{
            let medicine = try await medicineService.setDataToList(user: user, aisle: aisle)
            for medicines in medicine {
                try? await  addHistory(action: "Added \(medicines.name)", user: user, medicineId: medicines.id ?? "Unknow", details: "Added new medicine")
            }
        }catch{
            throw MedicineError.invalidSetData
        }
    }
    
    func setDataToAisle(name:String, stock:Int, aisle:String) async throws -> [Medicine] {
        do{
            return try await medicineService.setDataToAisle(name: name, stock: stock, aisle: aisle)
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
    
    func deleteAisle(aisles:[String], at offsets: IndexSet) async throws -> [String] {
        do{
            return try await medicineService.deleteAisle(aisles: aisles, at: offsets)
            
        } catch{
            throw MedicineError.invalidDelete
        }
        
    }
    
    private func addHistory(action: String, user: String, medicineId: String, details: String) async throws{
        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details)
        do {
            try db.collection("history").document(history.id ?? UUID().uuidString).setData(from: history)
        } catch let error {
            throw MedicineError.addHistoryThorughMedicineFailed(result:error)
        }
    }
    
    func updateMedicine(_ medicine: Medicine, user: String) async throws {
        do{
            let medicine = try await medicineService.updateMedicine(medicine, user: user)
            for medicines in medicine {
                try? await addHistory(action: "Updated \(medicines.name)", user: self.identity, medicineId: medicines.id ?? "Unknow", details: "Updated medicine details")
            }
        }catch{
            throw MedicineError.invalidMedicine
        }
    }
    
    func updateStock(_ medicine: Medicine, by amount: Int, user: String) async throws  {
        let medicine = medicineService.updateStock(medicine, by: amount, user: user)
        
        for medicines in medicine {
            let newStock = medicines.stock + amount
            try? await addHistory(action: "\(amount > 0 ? "Increased" : "Decreased") stock of \(medicines.name) by \(amount)", user: self.identity, medicineId: medicines.id ?? "Unknow", details: "Stock changed from \(medicines.stock) to \(newStock)")
        }
    }
    
    func fetchHistory(for medicine: Medicine, completion: @escaping([HistoryEntry])->Void) {
        medicineService.fetchHistory(for: medicine) { historyEntry in
            completion(historyEntry)
        }
    }
    
    
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
        medicineService.getAllElements { medicine in
            completion(medicine)
        }
    }
}


enum MedicineError: Error {
    case invalidDelete
    case invalidMedicine
    case invalidAisles
    case invalidSetData
    case addHistoryThorughMedicineFailed(result:Error)
    case medicineIsEmpty
    case aisleIsEmpty
}
