//
//  MedicineRepositoryTests.swift
//  MediStockTests
//
//  Created by KEITA on 29/01/2025.
//

import XCTest
@testable import pack

final class MedicineRepositoryTests: XCTestCase {
    var medicineRepository : MedicineRepository!
    var mockMedicineService : MockMedicineService!
    var mockCollection : MockCollectionReference!
    let mockData: [String: Any] = ["value": 42]
    let mockDocument = MockQueryDocumentSnapshotProtocol(mockData: ["String" : "Any"], documentID: "abs123")

    override func setUp() {
        super.setUp()
        mockMedicineService = MockMedicineService()
        mockMedicineService.collection = "medicines"
        mockMedicineService.mockDocuments = [mockDocument]
        mockCollection = MockCollectionReference(mockDocuments: [mockDocument])
        medicineRepository = MedicineRepository(medicines: [Medicine(name: "", stock: 11, aisle: "")], historyEntry: [HistoryEntry(medicineId: "", user: "", action: "", details: "")], db: mockMedicineService)
          }
  
}
