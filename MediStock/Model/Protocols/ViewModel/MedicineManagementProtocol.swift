//
//  MedicineProtocol.swift
//  pack
//
//  Created by Modibo on 26/03/2025.
//

import Foundation

protocol MedicineManagementProtocol {
    func fetchMedicines() async throws -> [Medicine]
    func fetchAisles() async throws -> [String]
    func setDataToList(user: String, name: String, stock: Int, aisle: String, stockValue: Int) async throws -> [Medicine]
    func setDataToAisle(name: String, stock: Int, aisle: String) async throws -> [Medicine]
    func delete(medicines: [Medicine], at offsets: IndexSet) async throws
    func deleteAisle(aisles: [String], at offsets: IndexSet) async throws -> [String]
    func addHistory(action: String, user: String, medicineId: String, details: String, stock: Int) async throws
    func updateMedicine(_ medicine: Medicine, user: String, stock: Int) async throws
    func updateStock(_ medicine: Medicine, by amount: Int, user: String, stock: Int) async throws
    func fetchHistory(for medicine: Medicine, completion: @escaping ([HistoryEntry]) -> Void)
    func trieByName(completion: @escaping ([Medicine]) -> Void)
    func trieByStock(completion: @escaping ([Medicine]) -> Void)
    func getAllElements(completion: @escaping ([Medicine]) -> Void)
}
