//
//  MedicineStockViewModelTests.swift
//  MediStockTests
//
//  Created by Modibo on 26/03/2025.
//

import Testing
import XCTest
@testable import pack
struct MedicineStockViewModelTests {

    @Test func fetchMedicines() async throws {
        //Give
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine = pack.Medicine.emptyStockMedicine_2
        mockMedicineServiceViewModel.mockMedicines = medicine
        //When
        let _ = try await medicineStockViewModel.observeMedicines()
        //Then
        XCTAssertEqual(medicineStockViewModel.medicines, medicine)
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func fetchMedicinesThrowsError() async throws {
        // Given
           let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
           let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
           mockMedicineServiceViewModel.shouldThrowError = true
           
        // When/Then
           do {
               try await medicineStockViewModel.observeMedicines() // Tentative de récupération des médicaments (async)
               XCTFail("Expected error, but the operation succeeded.")
           } catch let error {
               // Si une erreur est levée, vérifier son type
               XCTAssertEqual(error as? MedicineError, MedicineError.medicineIsEmpty)
           }

    }

    @Test func fetchAisles() async throws {
        //Give
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let aisles = ["Aisle 1", "Aisle 2"]
        mockMedicineServiceViewModel.mockAisles = aisles
        //When
        let _ = try await medicineStockViewModel.observeAisles()
        
        //Then
        #expect(medicineStockViewModel.aisles == aisles)
    }
    
    @Test func fetchAislesThrowsError() async throws {
        //Give
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        mockMedicineServiceViewModel.shouldThrowError = true
        //When/Then
        await #expect(throws: MedicineError.aisleIsEmpty) {
            let _ = try await medicineStockViewModel.observeAisles()
        }
    }
    
    @Test func insertAisle() async throws {
        //Give
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        //When
        let _ = try await medicineStockViewModel.insertAisle(name: "fakeName", stock: 55, aisle: "A7ZE")
        
        //Then
        #expect(mockMedicineServiceViewModel.mockMedicines.first?.name == "fakeName")
        #expect(mockMedicineServiceViewModel.mockMedicines.first?.stock == 55)
        #expect(mockMedicineServiceViewModel.mockMedicines.first?.aisle == "A7ZE")
        #expect(medicineStockViewModel.messageEror == nil)
    }
    
    @Test func whenInsertingAnAislesLessThanNameThrowsError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        
        //When
        let _ = try await medicineStockViewModel.insertAisle(name: "", stock: 55, aisle: "A7ZE")
        //Then
        XCTAssert(medicineStockViewModel.messageEror == "Please enter the medicine name.")
    }
    
    @Test func whenInsertingAnAislesLessThanAisleThrowsError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        
        //When
        let _ = try await medicineStockViewModel.insertAisle(name: "fakeName", stock: 55, aisle: "")
        //Then
        XCTAssert(medicineStockViewModel.messageEror == "Please select a category to proceed.")
    }
    
    @Test func insertAisleThrowsNoError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        mockMedicineServiceViewModel.shouldThrowError = true
        //When/Then
        await #expect(throws: ThrowsErrorReason.insertAisleThrowsError) {
            let _ = try await medicineStockViewModel.insertAisle(name: "fakeName", stock: 0, aisle: "A7ZE")
            #expect(medicineStockViewModel.messageEror == "An error occurred while adding a new medicine. Please check that it is not already present.")
        }
    }
    
    @Test func insertMedicineToListSuccess() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        
        //When
        let _ = try await medicineStockViewModel.insertMedicineToList(
            user: "fakeUser",
            name: "fakeName",
            stock: 200,
            aisle: "AISS",
            stockValue: 88
        )
        
        //Then
        XCTAssertEqual(mockMedicineServiceViewModel.mockMedicines.first?.name, "fakeName")
            XCTAssertEqual(mockMedicineServiceViewModel.mockMedicines.first?.stock, 200)
            XCTAssertEqual(mockMedicineServiceViewModel.mockMedicines.first?.aisle, "AISS")
            XCTAssertNil(medicineStockViewModel.messageEror)
    }
    
    @Test func insertMedicineToLisLessNameStock() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        
        //When
        let _ = try await medicineStockViewModel.insertMedicineToList(
            user: "fakeUser",
            name: "",
            stock: 200,
            aisle: "AISS",
            stockValue: 88
        )
        //Then
        XCTAssertEqual(medicineStockViewModel.messageEror, "Please enter the medicine name.")

    }
    
    @Test func insertMedicineToLisLessAisleStock() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        
        //When
        let _ = try await medicineStockViewModel.insertMedicineToList(
            user: "fakeUser",
            name: "fakeName",
            stock: 200,
            aisle: "",
            stockValue: 88
        )
        //Then
        #expect(medicineStockViewModel.messageEror == "Please select a category to proceed.")
    }
    
    @Test func insertMedicineToLisThrowError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        mockMedicineServiceViewModel.shouldThrowError = true
        //When/Then
        await #expect(throws: ThrowsErrorReason.insertMedicineToListThrowError) {
            let _ = try await medicineStockViewModel.insertMedicineToList(
                user: "fakeUser",
                name: "fakeName",
                stock: 200,
                aisle: "AISS",
                stockValue: 88
            )
            #expect(medicineStockViewModel.messageEror == "An error occurred while adding a new medicine. Please check that it is not already present.")
        }
    }
    
    @Test func deleteMediceFromList() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        mockMedicineServiceViewModel.mockMedicines = Medicine.testMedicine

        //When
        let _ = try await medicineStockViewModel.deleteMedicines(
            at: IndexSet(integer: 0)
        )
        //Then
        #expect(mockMedicineServiceViewModel.mockMedicines == [])
    }
    
    @Test func deleteMediceFromListThrowsError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        mockMedicineServiceViewModel.shouldThrowError = true

        //When/Then
        await #expect(throws:ThrowsErrorReason.deleteMedicinesThrowsError) {
            let _ = try await medicineStockViewModel.deleteMedicines(
                at: IndexSet(integer: 1)
            )
        }
    }
    
    @Test func deleteAislesInMedicineList() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        mockMedicineServiceViewModel.mockAisles = ["AISLE 1"]

        //When
        let _ = try await medicineStockViewModel.deleteAisle(
            at: IndexSet(integer: 0)
        )
        //Then
        #expect(mockMedicineServiceViewModel.mockAisles == [])
    }
    
    @Test func deleteAislesIntMedicineListThrowsError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        mockMedicineServiceViewModel.shouldThrowError = true

        //When/Then
        await #expect(throws:ThrowsErrorReason.deleteMedicinesThrowsError){
            let _ = try await medicineStockViewModel.deleteAisle(
                at: IndexSet(integer: 0)
            )
        }
    }
    
    @Test func changeStock() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine = Medicine.emptyStockMedicine_3
        let medicin_2 = Medicine.emptyStockMedicine_2
        mockMedicineServiceViewModel.mockMedicines = medicin_2
        //When
        let _ = try await medicineStockViewModel.changeStock(
            medicine,
            user: "Jack",
            stocks: 44,
            stockValue: 33
        )
        //Then
        #expect(mockMedicineServiceViewModel.mockMedicines.first?.stock == 44)
    }
    
    @Test func changeStockThrowsError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine = Medicine.emptyStockMedicine_3
        mockMedicineServiceViewModel.shouldThrowError = true
        //When/Then
        await #expect(throws: ThrowsErrorReason.changeStockThrowsError) {
            let _ = try await medicineStockViewModel.changeStock(
                medicine,
                user: "Jack",
                stocks: 44,
                stockValue: 33
            )
        }
    }
    
    @Test func updateMedicine() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine = Medicine.emptyStockMedicine_3
        let medicin_2 = Medicine.testMedicine
        mockMedicineServiceViewModel.mockMedicines = medicin_2
        
        //When
        let _ = try await medicineStockViewModel.updateMedicine(
            medicine,
            user: "Jrix_55",
            stock: 77
        )
        
        //Then
        #expect(mockMedicineServiceViewModel.mockMedicines.first?.name == "Ibuprofen")
    }
    
    @Test func updateMedicineThrowError() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine = Medicine.emptyStockMedicine_3
        mockMedicineServiceViewModel.shouldThrowError = true 
      
        //When/Then
        await #expect(throws: ThrowsErrorReason.updateMedicineThrowsError) {
            let _ = try await medicineStockViewModel.updateMedicine(
                medicine,
                user: "Jrix_55",
                stock: 77
            )
        }
    }
    
    @Test func trieElementsByName() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine1 = Medicine(id: "1", name: "Ibuprofen", stock: 15, aisle: "B2")
        let medicine2 = Medicine(id: "2", name: "Aspirin", stock: 20, aisle: "A1")
        mockMedicineServiceViewModel.mockMedicines = [medicine1,medicine2]
        
        //When
        try await medicineStockViewModel.trieElements(option: .name)
        
        //Then
        #expect(medicineStockViewModel.medicines.first?.stock == 20)
        #expect(medicineStockViewModel.medicines.first?.aisle == "A1")
        #expect(medicineStockViewModel.medicines.first?.name == "Aspirin")
        #expect(medicineStockViewModel.medicines.first?.id == "2")
    }
    
    @Test func triElementsByStock() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine1 = Medicine(id: "1", name: "Ibuprofen", stock: 15, aisle: "B2")
        let medicine2 = Medicine(id: "2", name: "Aspirin", stock: 20, aisle: "A1")
        mockMedicineServiceViewModel.mockMedicines = [medicine1,medicine2]
        
        //When
        try await medicineStockViewModel.trieElements(option: .stock)
        
        //Then
        #expect(medicineStockViewModel.medicines.first?.stock == 20)
        #expect(medicineStockViewModel.medicines.first?.aisle == "A1")
        #expect(medicineStockViewModel.medicines.first?.name == "Aspirin")
        #expect(medicineStockViewModel.medicines.first?.id == "2")
    }
    
    @Test func noTriElementsByStockOrName() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine1 = Medicine(id: "1", name: "Ibuprofen", stock: 15, aisle: "B2")
        let medicine2 = Medicine(id: "2", name: "Aspirin", stock: 20, aisle: "A1")
        mockMedicineServiceViewModel.mockMedicines = [medicine1,medicine2]
        
        //When
        try await medicineStockViewModel.trieElements(option: .noFilter)
        
        //Then
        #expect(medicineStockViewModel.medicines.first?.stock == 15)
        #expect(medicineStockViewModel.medicines.first?.aisle == "B2")
        #expect(medicineStockViewModel.medicines.first?.name == "Ibuprofen")
        #expect(medicineStockViewModel.medicines.first?.id == "1")
    }
    
    @Test func fetchHistory() async throws {
        //Given
        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
        let medicineStockViewModel = MedicineStockViewModel(medicineRepository:mockMedicineServiceViewModel)
        let medicine = Medicine.emptyStockMedicine_3
        
        //When
        medicineStockViewModel.fetchHistory(for: medicine)
        
        //Then
        #expect(medicineStockViewModel.history != nil)
    }
}
