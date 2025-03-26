//
//  MockMedicineServiceViewModel.swift
//  MediStockTests
//
//  Created by Modibo on 26/03/2025.
//

@testable import pack
import Foundation

class MockMedicineServiceViewModel : MedicineManagementProtocol{
    var mockMedicines: [Medicine] = []
    var mockAisles: [String] = []
    var mockHistory: [HistoryEntry] = []
    var shouldThrowError: Bool = false
    
    func fetchMedicines() async throws -> [pack.Medicine] {
        if shouldThrowError { throw MedicineError.medicineIsEmpty }
        return mockMedicines
    }
    
    func fetchAisles() async throws -> [String] {
        if shouldThrowError { throw MedicineError.aisleIsEmpty }
        return mockAisles
    }
    
    func setDataToList(user: String, name: String, stock: Int, aisle: String, stockValue: Int) async throws -> [pack.Medicine] {
        if shouldThrowError { throw ThrowsErrorReason.insertMedicineToListThrowError }
        let newMedicine = Medicine(id: UUID().uuidString, name: name, stock: stock, aisle: aisle)
        mockMedicines.append(newMedicine)
        return mockMedicines
    }
    
    func setDataToAisle(name: String, stock: Int, aisle: String) async throws -> [pack.Medicine] {
        if shouldThrowError { throw ThrowsErrorReason.insertAisleThrowsError }
        let newMedicine = Medicine(id: UUID().uuidString, name: name, stock: stock, aisle: aisle)
        mockMedicines.append(newMedicine)
        return mockMedicines
    }
    
    func delete(medicines: [pack.Medicine], at offsets: IndexSet) async throws {
        if shouldThrowError { throw ThrowsErrorReason.deleteMedicinesThrowsError }
        mockMedicines.remove(atOffsets: offsets)
    }
    
    func deleteAisle(aisles: [String], at offsets: IndexSet) async throws -> [String] {
        if shouldThrowError { throw ThrowsErrorReason.deleteMedicinesThrowsError}
        mockAisles.remove(atOffsets: offsets)
        return mockAisles
    }
    
    func addHistory(action: String, user: String, medicineId: String, details: String, stock: Int) async throws {
        if shouldThrowError { throw MedicineError.addHistoryThorughMedicineFailed }
        let newEntry = HistoryEntry(
            id: UUID().uuidString,
            medicineId: action,
            user: user,
            action: medicineId,
            details: details,
            timestamp: Date.now, stock: stock
        )
        mockHistory.append(newEntry)
    }
    
    func updateMedicine(_ medicine: pack.Medicine, user: String, stock: Int) async throws {
        if shouldThrowError { throw ThrowsErrorReason.updateMedicineThrowsError }
        if let index = mockMedicines.firstIndex(where: { $0.id == medicine.id }) {
            mockMedicines[index] = medicine
        }
    }
    
    func updateStock(_ medicine: pack.Medicine, by amount: Int, user: String, stock: Int) async throws {
        if shouldThrowError { throw ThrowsErrorReason.changeStockThrowsError}
        if let index = mockMedicines.firstIndex(where: { $0.id == medicine.id }) {
            mockMedicines[index].stock += amount
        }
    }
    
    func fetchHistory(for medicine: pack.Medicine,
        completion: @escaping ([pack.HistoryEntry]) -> Void) {
        let filteredHistory = mockHistory.filter { $0.medicineId == medicine.id }
        completion(filteredHistory)
    }
    
    func trieByName(completion: @escaping ([pack.Medicine]) -> Void) {
        let sorted = mockMedicines.sorted { $0.name < $1.name }
        completion(sorted)
    }
    
    func trieByStock(completion: @escaping ([pack.Medicine]) -> Void) {
        let sorted = mockMedicines.sorted { $0.stock > $1.stock }
        completion(sorted)
    }
    
    func getAllElements(completion: @escaping ([pack.Medicine]) -> Void) {
        completion(mockMedicines)
    }
}
