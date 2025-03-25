//
//  MockMedicineService.swift
//  MediStockTests
//
//  Created by KEITA on 29/01/2025.
//
import XCTest
@testable import pack
import FirebaseFirestore

class MockMedicineService: MedicineProtocol{
    var showErrors : Bool = false
    var medicines : [pack.Medicine] = []
    var updateName : String = ""
    var historyEntry : [pack.HistoryEntry] = []
    var testAisles: [String] = ["A1", "B2", "C3"]
    func fetchMedicines() async throws -> [Medicine] {
        if showErrors {
             Medicine.emptyMedicine
            throw MedicineError.medicineIsEmpty
        }else{
            Medicine.testMedicine
           
        }
    }

    func fetchAisles() async throws -> [String] {
        if showErrors {
            throw MedicineError.aisleIsEmpty
        }else{
            return testAisles
        }
    }

    func setDataToList(user: String, name: String, stock: Int, aisle: String) async throws -> [pack.Medicine] {
        if name == "Doliprane" && stock == 10 && aisle == "A2" && !user.isEmpty {
            pack.Medicine.testMedicine
        }else{
            throw MedicineError.invalidSetData
        }
    }

    func delete(medicines: [pack.Medicine], at offsets: IndexSet) async throws {
        if showErrors {
            throw MedicineError.invalidDelete
        }else{
            var mutableMedicine = medicines
            for index in offsets.sorted(by:>) {
                if index < mutableMedicine.count {
                    mutableMedicine.remove(at: index)
                }
            }
        }
    }

    func deleteAisle(aisles: [String], at offsets: IndexSet) async throws -> [String] {
        if showErrors {
            throw MedicineError.invalidDelete
        }else{
            var mutableMedicine = aisles
            for index in offsets.sorted(by:>) {
                if index < mutableMedicine.count {
                    mutableMedicine.remove(at: index)
                }
            }
            return mutableMedicine
        }
    }

    func updateMedicine(_ medicine: pack.Medicine, user: String) async throws -> [pack.Medicine] {
        if showErrors {
            throw MedicineError.invalidMedicine
        }else {
            if let index = medicines.firstIndex(where: { $0.id == medicine.id }){
                medicines[index].name = updateName
            }else{
                throw MedicineError.invalidMedicine
            }
            return [medicine]
        }
    }

    func updateStock(_ medicine: pack.Medicine, by amount: Int, user: String) -> [pack.Medicine] {
        if showErrors {
            historyEntry = []
            return medicines
        }else {
            if let index = medicines.firstIndex(where: { $0.id == medicine.id }){
                medicines[index].stock = amount
            }
            historyEntry = pack.HistoryEntry.testHistoryEntry
            return [medicine]
        }
    }

    func fetchHistory(for medicine: pack.Medicine,completion: @escaping ([pack.HistoryEntry]) -> Void) {
        if showErrors {
            completion(historyEntry)
        }else{
            completion([])
        }
    }

    func trieByName(completion: @escaping ([pack.Medicine]) -> Void) {
        if showErrors {
            completion(medicines)
        }else{
            completion([])
        }
    }

    func trieByStock(completion: @escaping ([pack.Medicine]) -> Void) {
        if showErrors {
            completion(medicines)
        }else{
            completion([])
        }
    }

    func getAllElements(completion: @escaping ([pack.Medicine]) -> Void) {
        if showErrors {
            completion(medicines)
        }else{
            completion([])
        }
    }

    func setDataToAisle(name: String, stock: Int, aisle: String) async throws -> [pack.Medicine] {
        if showErrors && name.isEmpty && stock <= 0 && aisle.isEmpty{
            return medicines
        }else{
            return pack.Medicine.testMedicine
        }
    }
}
