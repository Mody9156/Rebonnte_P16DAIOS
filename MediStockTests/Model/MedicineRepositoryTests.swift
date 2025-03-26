////
////  MedicineRepositoryTests.swift
////  MediStockTests
////
////  Created by Modibo on 24/03/2025.
////
//import Testing
//@testable import pack
//import XCTest
//struct MedicineRepositoryTests {
//    
//    @Test func fetchMedicinesReturnsValidData() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        //When/Then
//        await #expect(throws: Never.self) {
//            let user = try await  medicineRepository.fetchMedicines()
//            #expect(user != [])
//        }
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//    }
//    
//    @Test func fetchMedicinesReturnsEmptyData() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        //When
//        await #expect(throws:  MedicineError.medicineIsEmpty) {
//            let medicine = try await  medicineRepository.fetchMedicines()
//            #expect(medicine == [])
//        }
//    }
//    
//    @Test
//    func fetchAislesNoThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        
//        //When/Then
//        await #expect(throws: Never.self){
//            let medicine = try await  medicineRepository.fetchAisles()
//            #expect(!medicine.isEmpty)
//        }
//    }
//    
//    @Test func fetAislesReturnsEmptyData() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        //When/Then
//        await #expect(throws:  MedicineError.aisleIsEmpty) {
//            let user = try await  medicineRepository.fetchAisles()
//            #expect(user == [])
//        }
//    }
//    
//    @Test func setDataToListNoThrowErrors() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        
//        //When/Then
//        await #expect(throws: Never.self) {
//            let medicine = try await medicineRepository.setDataToList(
//                user: "fake",
//                name: "Doliprane",
//                stock: 10,
//                aisle: "A2",
//                stockValue: 10
//            )
//            
//            #expect(!medicine.isEmpty)
//        }
//    }
//    
//    @Test
//    func testSetDataToListThrowsError() async throws {
//        // Given
//        let mockMedicineService = MockMedicineService()
//        mockMedicineService.showErrors = true // Force l'erreur
//        
//        let medicineRepository = MedicineRepository(medicineService: mockMedicineService)
//        
//        // When/Then
//        await #expect(throws: MedicineError.invalidSetData) {
//            try await medicineRepository.setDataToList(
//                user: "",
//                name: "Unknown",
//                stock: 5,
//                aisle: "Z9",
//                stockValue: 5
//            )
//        }
//    }
//    
//    @Test func setDataToAisleNoThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        //When/Then
//        await #expect(throws: Never.self) {
//            let medecine = try await medicineRepository.setDataToAisle(
//                name: "fake_1",
//                stock: 10,
//                aisle: "A77d"
//            )
//            #expect(medecine == pack.Medicine.testMedicine)
//            #expect(medecine != [])
//        }
//    }
//    
//    @Test func setDataToAisleThrowsError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        //When/Then
//        await #expect(throws: MedicineError.invalidSetData) {
//            try await medicineRepository.setDataToAisle(
//                name: "",
//                stock: -1,
//                aisle: ""
//            )
//        }
//    }
//    
//    @Test func deteRightAisleNoThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        let deleteIndexes = IndexSet([1])
//        let initialCount = mockMedicineService.testMedicines.count
//        //When/Then
//        await #expect(throws: Never.self) {
//            try await medicineRepository.delete(
//                medicines: mockMedicineService.testMedicines,
//                at: deleteIndexes
//            )
//            #expect( mockMedicineService.testMedicines.count == initialCount - 1)
//        }
//    }
//    
//    @Test func deleteBadIndexThrowsError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        let deleteIndexes = IndexSet([0])
//        //When/Then
//        await #expect(throws: MedicineError.invalidDelete) {
//            try await medicineRepository.delete(
//                medicines: mockMedicineService.testMedicines,
//                at: deleteIndexes
//            )
//        }
//    }
//    
//    @Test func deleteAisleNotFoundThrowsError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        let initialCount = mockMedicineService.testAisles.count
//        let deleteIndexes = IndexSet([1])
//        //When/Then
//        await #expect(throws: Never.self) {
//            try await medicineRepository.deleteAisle(
//                aisles: mockMedicineService.testAisles,
//                at: deleteIndexes
//            )
//            #expect(mockMedicineService.testAisles.count == initialCount - 1)
//        }
//    }
//    
//    @Test func deleteAisleThrowsErrorWhenServiceThrows() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        let deleteIndexes = IndexSet([0])
//        //When/Then
//        await #expect(throws: MedicineError.invalidDelete){
//            try await medicineRepository
//                .deleteAisle(aisles: mockMedicineService.testAisles, at: deleteIndexes)
//        }
//    }
//    
//    @Test func updateMedicineNoThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        let originalMedicine = pack.Medicine(id: "1", name: "Doliprane", stock: 10, aisle: "A2")
//        
//        mockMedicineService.testMedicines = [originalMedicine]
//        mockMedicineService.updateName = "UpdatedDoliprane" // Nom mis à jour
//        
//        //When/Then
//        await #expect(throws: Never.self) {
//            let updatedMedicines: () = try await medicineRepository
//                .updateMedicine(originalMedicine, user: "fakeUser", stock: 3)
//        }
//    }
//    
//    @Test func updateMedicineThroughServiceThrowsError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        let originalMedicine = pack.Medicine(id: "1", name: "Doliprane", stock: 10, aisle: "A2")
//        
//        mockMedicineService.showErrors = true
//        mockMedicineService.testMedicines = []
//        mockMedicineService.updateName = "UpdatedDoliprane"
//        //When/Then
//        await #expect(throws: MedicineError.invalidMedicine) {
//            try await medicineRepository.updateMedicine(originalMedicine, user: "fakeUser", stock: 22)
//        }
//    }
//    
//    
//    @Test  func fetchHistoryNoThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        
//        //When/Then
//        #expect(throws: Never.self){
//            medicineRepository
//                .fetchHistory(
//                    for: pack.Medicine.emptyStockMedicine_3) { history in
//                        XCTAssertNotNil(history)
//                    }
//        }
//    }
//    
//    @Test func fetchHistoryThrowsError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        
//        //When/Then
//        medicineRepository
//            .fetchHistory(
//                for: pack.Medicine.emptyStockMedicine_3) { history in
//                    #expect(history == [])
//                }
//        
//    }
//    
//    @Test func trieByNameNoTthrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        
//        //When/Then
//        medicineRepository.trieByName{ medicines in
//            #expect(medicines == [])
//        }
//    }
//    
//    @Test func trieByNameThrowsError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        
//        //When/Then
//        medicineRepository.trieByName { medicine in
//            #expect(medicine.isEmpty == true)
//        }
//    }
//    
//    @Test func trieByStockNoThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        
//        //When
//        medicineRepository.trieByStock { medicines in
//            #expect(medicines.isEmpty == true)
//
//        }
//    }
//    @Test func trieByStockThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        //When
//        medicineRepository.trieByStock{ medicines in
//            #expect(medicines  == [])
//        }
//    }
//    
//    @Test func getAllElementsNotThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        
//        //WhenThen
//        medicineRepository.getAllElements { medicine in
//            #expect(medicine == [])
//
//        }
//    }
//    
//    @Test func getAllElementsThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        
//        //WhenThen
//        medicineRepository.getAllElements { medicine in
//            #expect(medicine == [])
//        }
//    }
//    
//    @Test func updateStockNotThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        let testMedicine = pack.Medicine(id: "123", name: "Doliprane", stock: 5, aisle: "A1")
//        mockMedicineService.testMedicines = [testMedicine]
//                
//        //When
//        let stock : () = try await medicineRepository.updateStock(
//            testMedicine,
//            by: 10,
//            user: "testUser",
//            stock: 10
//        )
//        
//        //Then
//        #expect(stock == ())
//        #expect(mockMedicineService.historyEntry.first?.action == "Update")
//        #expect(mockMedicineService.historyEntry.first?.stock == 50)
//        #expect(mockMedicineService.testMedicines.first?.stock == 10)
//    }
//    
//    @Test func updateStoctThrowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        let testMedicine = pack.Medicine(id: "123", name: "Doliprane", stock: 5, aisle: "A1")
//        mockMedicineService.showErrors = true
//        //When
//         try await medicineRepository.updateStock(
//            testMedicine,
//            by: 10,
//            user: "",
//            stock: 10
//        )
//        
//        //Then
//        #expect(mockMedicineService.historyEntry.isEmpty)
//        #expect(mockMedicineService.medicines == [])
//        
//    }
//    
//    @Test func addHistoryNoThowError() async throws {
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        
//        //When
//        let history =  try await medicineRepository
//            .addHistory(action: "update", user: "Josh", medicineId: "aisle", details: "update +21", stock: 120)
//        
//        //Then
//        #expect(medicineRepository.historyEntry == [])
//        #expect(mockMedicineService.historyEntry.first?.action == "aisle")
//    }
//    
//    @Test func addHistoryThowError() async throws{
//        //Given
//        let mockMedicineService = MockMedicineService()
//        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
//        mockMedicineService.showErrors = true
//        
//        //When/Then
//        await #expect(throws: MedicineError.addHistoryThorughMedicineFailed) {
//            try await medicineRepository.addHistory(action: "", user: "", medicineId: "", details: "", stock: -1)
//        }
//       
//    }
//}
