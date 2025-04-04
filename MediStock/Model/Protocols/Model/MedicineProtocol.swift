//
//  MedicineProtocol.swift
//  pack
//
//  Created by KEITA on 31/01/2025.
//

import Foundation

protocol MedicineProtocol{
    func fetchMedicines() async throws -> [Medicine] 
    func fetchAisles() async throws -> [String] 
//    func setData(user: String) async throws -> [Medicine]
    func setDataToList(user: String,name:String, stock:Int, aisle:String) async throws -> [Medicine]
    func delete(medicines: [Medicine], at offsets: IndexSet) async throws
    func deleteAisle(aisles:[String], at offsets: IndexSet) async throws -> [String]
    func updateMedicine(_ medicine: Medicine, user: String) async throws -> [Medicine]
    func updateStock(_ medicine: Medicine, by amount: Int, user: String) -> [Medicine]
    func fetchHistory(for medicine: Medicine, completion: @escaping([HistoryEntry])->Void)
    func trieByName(completion:@escaping([Medicine]) ->Void)
    func trieByStock(completion:@escaping([Medicine]) ->Void)
    func getAllElements(completion:@escaping([Medicine]) -> Void)
    func setDataToAisle(name:String, stock:Int, aisle:String) async throws -> [Medicine]
    func addHistory(action: String, user: String, medicineId: String, details: String, stock: Int) async throws

}
