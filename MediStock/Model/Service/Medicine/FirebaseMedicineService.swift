//
//  FirebaseMedicineService.swift
//  pack
//
//  Created by KEITA on 29/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseMedicineService : MedicineServiceProtocol {
    func fetchMedicines(completion: @escaping ([Medicine]) -> Void) {
        <#code#>
    }
    
    func fetchAisles(completion: @escaping ([String]) -> Void) {
        <#code#>
    }
    
    func setData(user: String) async throws {
        <#code#>
    }
    
    func setDataToList(user: String, aisle: String) async throws {
        <#code#>
    }
    
    func delete(medicines: [Medicine], at offsets: IndexSet) {
        <#code#>
    }
    
    func addHistory(action: String, user: String, medicineId: String, details: String) {
        <#code#>
    }
    
    func updateMedicine(_ medicine: Medicine, user: String) {
        <#code#>
    }
    
    func updateStock(_ medicine: Medicine, by amount: Int, user: String) {
        <#code#>
    }
    
    func fetchHistory(for medicine: Medicine, completion: @escaping ([HistoryEntry]) -> Void) {
        <#code#>
    }
    
    func trieByName(completion: @escaping ([Medicine]) -> Void) {
        <#code#>
    }
    
    func trieByStock(completion: @escaping ([Medicine]) -> Void) {
        <#code#>
    }
    
    func getAllElements(completion: @escaping ([Medicine]) -> Void) {
        <#code#>
    }
    
    
}
