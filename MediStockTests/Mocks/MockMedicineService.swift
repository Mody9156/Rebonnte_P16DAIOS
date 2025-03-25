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

    func fetchMedicines(completion: @escaping ([pack.Medicine]) -> Void) {
        if showErrors {
            medicines = Medicine.emptyMedicine
        }else{
            medicines = Medicine.testMedicine
        }
    }

    func fetchAisles(completion: @escaping ([String]) -> Void) {
        if showErrors {
            medicines = Medicine.emptyMedicine
        }else{
            medicines = Medicine.testMedicine
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
            var mutableMedicine = medicines
            for index in offsets.sorted(by:>) {
                if index < mutableMedicine.count {
                    mutableMedicine.remove(at: index)
                }
            }
        }
    }

    func updateMedicine(_ medicine: pack.Medicine, user: String) async throws -> [pack.Medicine] {
        <#code#>
    }

    func updateStock(_ medicine: pack.Medicine, by amount: Int, user: String) -> [pack.Medicine] {
        <#code#>
    }

    func fetchHistory(
        for medicine: pack.Medicine,
        completion: @escaping ([pack.HistoryEntry]) -> Void
    ) {
        <#code#>
    }

    func trieByName(completion: @escaping ([pack.Medicine]) -> Void) {
        <#code#>
    }

    func trieByStock(completion: @escaping ([pack.Medicine]) -> Void) {
        <#code#>
    }

    func getAllElements(completion: @escaping ([pack.Medicine]) -> Void) {
        <#code#>
    }

    func setDataToAisle(name: String, stock: Int, aisle: String) async throws -> [pack.Medicine] {
        <#code#>
    }

}
