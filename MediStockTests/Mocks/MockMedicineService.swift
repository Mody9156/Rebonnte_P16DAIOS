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
    var testMedicines: [pack.Medicine] = [
           pack.Medicine(id: "1", name: "Doliprane", stock: 10, aisle: "A2"),
           pack.Medicine(id: "2", name: "Aspirine", stock: 5, aisle: "B3"),
           pack.Medicine(id: "3", name: "Paracétamol", stock: 8, aisle: "C1")
       ]
 
    func fetchMedicines() async throws -> [Medicine] {
        if showErrors {
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
        if name == "Doliprane" && stock == 10 && aisle == "A2" && !user.isEmpty{
            pack.Medicine.testMedicine
        }else{
            throw MedicineError.invalidSetData
        }
    }

    func delete(medicines: [pack.Medicine], at offsets: IndexSet) async throws {
        if showErrors {
            throw MedicineError.invalidDelete
        }else{
            for index in offsets.sorted(by:>) {
                if index < testMedicines.count {
                    testMedicines.remove(at: index)
                }
            }
        }
    }

    func deleteAisle(aisles: [String], at offsets: IndexSet) async throws -> [String] {
        if showErrors {
            throw MedicineError.invalidDelete
        }else{
            for index in offsets.sorted(by:>) {
                if index < testAisles.count {
                    testAisles.remove(at: index)
                }
            }
            return testAisles
        }
    }

    func updateMedicine(_ medicine: pack.Medicine, user: String) async throws -> [pack.Medicine] {
        if showErrors {
                  throw MedicineError.invalidMedicine
              }
              if let index = testMedicines.firstIndex(where: { $0.id == medicine.id }) {
                  testMedicines[index].name = updateName
                  return [testMedicines[index]]
              } else {
                  throw MedicineError.invalidMedicine
              }
    }

    func updateStock(_ medicine: pack.Medicine, by amount: Int, user: String) -> [pack.Medicine] {
        if showErrors {
            historyEntry = []
            return medicines
        }else {
            var array : [Medicine] = []
            if let index = testMedicines.firstIndex(where: { $0.id == medicine.id }){
                testMedicines[index].stock = amount
                historyEntry = pack.HistoryEntry.testHistoryEntry
                array = [testMedicines[index]]
            }
            return array
        }
    }

    func fetchHistory(for medicine: pack.Medicine,completion: @escaping ([pack.HistoryEntry]) -> Void) {
        if showErrors {
            completion([])
        }else{
            completion(historyEntry)
        }
    }

    func trieByName(completion: @escaping ([pack.Medicine]) -> Void) {
        if showErrors {
            completion([])
        }else{
            completion(medicines)
        }
    }

    func trieByStock(completion: @escaping ([pack.Medicine]) -> Void) {
        if showErrors {
            completion([])
        }else{
            completion(medicines)
        }
    }

    func getAllElements(completion: @escaping ([pack.Medicine]) -> Void) {
        if showErrors {
            completion([])
        }else{
            completion(medicines)
        }
    }

    func setDataToAisle(name: String, stock: Int, aisle: String) async throws -> [pack.Medicine] {
        if showErrors && name.isEmpty && stock <= 0 && aisle.isEmpty{
            throw MedicineError.invalidSetData  
        }else{
            return pack.Medicine.testMedicine
        }
    }
    
    func addHistory(action: String, user: String, medicineId: String, details: String, stock: Int) async throws{
        if showErrors{
            throw MedicineError.addHistoryThorughMedicineFailed
        }else{
            let newEntry = pack.HistoryEntry(
                            id: UUID().uuidString,
                            medicineId: action,
                            user: user,
                            action: medicineId,
                            details: details,
                            timestamp: Date.now,
                            stock:stock
                        )
            historyEntry.append(newEntry)
        }
    }
}
