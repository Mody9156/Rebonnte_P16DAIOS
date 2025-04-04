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

class MedicineRepository: ObservableObject, MedicineManagementProtocol {
   
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
    
    func fetchMedicines() async throws -> [Medicine] {
        do {
            let user = try await  medicineService.fetchMedicines()
            return user
        }catch {
            throw MedicineError.medicineIsEmpty
        }
    }
    
    func fetchAisles() async throws -> [String]  {
        do{
            let medicine = try await medicineService.fetchAisles()
            return medicine
        }catch{
            throw MedicineError.aisleIsEmpty
        }

    }

    func setDataToList(user: String,name:String, stock:Int, aisle:String, stockValue:Int) async throws -> [Medicine] {
        do{
            let medicine = try await medicineService.setDataToList(user: user, name:name, stock:stock, aisle:aisle)
            for medicines in medicine {
                try? await  addHistory(action: "Added \(medicines.name)", user: user, medicineId: medicines.id ?? "Unknow", details: "Added new medicine", stock: stockValue)
            }
            return medicine
            
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
    
     func addHistory(action: String, user: String, medicineId: String, details: String, stock: Int) async throws{
         do{
             try await medicineService
                 .addHistory(action: action, user: user, medicineId: medicineId, details: details, stock: stock)
         }catch{
             throw MedicineError.addHistoryThorughMedicineFailed
         }
    }
    
    func updateMedicine(_ medicine: Medicine, user: String, stock:Int) async throws {
        do{
            let _ = try await medicineService.updateMedicine(medicine, user: user)
        }catch{
            throw MedicineError.invalidMedicine
        }
    }
    
    func updateStock(_ medicine: Medicine, by amount: Int, user: String, stock:Int) async throws  {
        let medicine = medicineService.updateStock(medicine, by: amount, user: user)
        
        for medicines in medicine {
            try? await addHistory(action: "\(amount > 0 ? "Increased" : "Decreased") stock of \(medicines.name) by \(amount)", user: self.identity, medicineId: medicines.id ?? "Unknow", details: "Stock changed from \(medicines.stock) to \( medicines.stock - stock )", stock: stock)
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


enum MedicineError: Error, Equatable {
    
    static func == (lhs: MedicineError, rhs: MedicineError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidDelete, .invalidDelete),
            (.invalidMedicine, .invalidMedicine),
            (.invalidAisles, .invalidAisles),
            (.invalidSetData, .invalidSetData),
            (.medicineIsEmpty, .medicineIsEmpty),
            (.aisleIsEmpty, .aisleIsEmpty):
            return true
            
        case (.addHistoryThorughMedicineFailed, .addHistoryThorughMedicineFailed):
            return false
            
        default:
            return false
        }
    }
    
    case invalidDelete
    case invalidMedicine
    case invalidAisles
    case invalidSetData
    case addHistoryThorughMedicineFailed
    case medicineIsEmpty
    case aisleIsEmpty
}
