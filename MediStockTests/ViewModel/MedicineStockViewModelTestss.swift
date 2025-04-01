////
////  MedicineStockViewModelTestss.swift
////  MediStockTests
////
////  Created by Modibo on 26/03/2025.
////
//
//// MedicineStockViewModelTests.swift
//// MediStockTests
//// Created by Modibo on 26/03/2025.
//
//import XCTest
//@testable import pack
//
//class MedicineStockViewModelTestss: XCTestCase {
//
//    // Test fetchMedicines functionality
//    func testFetchMedicines() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        let medicine = pack.Medicine.emptyStockMedicine_2
//        mockMedicineServiceViewModel.mockMedicines = medicine
//        
//        // When
//        let _ = try await medicineStockViewModel.observeMedicines()
//        
//        // Then
//        XCTAssertEqual(medicineStockViewModel.medicines, medicine)
//    }
//    
//    // Test fetchMedicines throws error
//    func testFetchMedicinesThrowsError() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        mockMedicineServiceViewModel.shouldThrowError = true
//        
//        // When/Then
//        do {
//            let _ = try await medicineStockViewModel.observeMedicines()
//            XCTFail("Expected error, but the operation succeeded.")
//        } catch let error {
//            XCTAssertEqual(error as? MedicineError, MedicineError.medicineIsEmpty)
//        }
//    }
//    
//    // Test fetchAisles functionality
//    func testFetchAisles() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        let aisles = ["Aisle 1", "Aisle 2"]
//        mockMedicineServiceViewModel.mockAisles = aisles
//        
//        // When
//        let _ = try await medicineStockViewModel.observeAisles()
//        
//        // Then
//        XCTAssertEqual(medicineStockViewModel.aisles, aisles)
//    }
//    
//    // Test fetchAisles throws error
//    func testFetchAislesThrowsError() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        mockMedicineServiceViewModel.shouldThrowError = true
//        
//        // When/Then
//        do {
//            let _ = try await medicineStockViewModel.observeAisles()
//            XCTFail("Expected error, but the operation succeeded.")
//        } catch let error as MedicineError {
//            XCTAssertEqual(error, MedicineError.aisleIsEmpty)
//        }
//    }
//    
//    // Test insertAisle functionality
//    func testInsertAisle() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        
//        // When
//        let _ = try await medicineStockViewModel.insertAisle(name: "fakeName", stock: 55, aisle: "A7ZE")
//        
//        // Then
//        XCTAssertEqual(mockMedicineServiceViewModel.mockMedicines.first?.name, "fakeName")
//        XCTAssertEqual(mockMedicineServiceViewModel.mockMedicines.first?.stock, 55)
//        XCTAssertEqual(mockMedicineServiceViewModel.mockMedicines.first?.aisle, "A7ZE")
//        XCTAssertNil(medicineStockViewModel.messageEror)
//    }
//    
//    // Test inserting aisle with empty name
//    func testInsertAisleWithEmptyNameThrowsError() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        
//        // When
//        let _ = try await medicineStockViewModel.insertAisle(name: "", stock: 55, aisle: "A7ZE")
//        
//        // Then
//        XCTAssertEqual(medicineStockViewModel.messageEror, "Please enter the medicine name.")
//    }
//    
//    // Test inserting aisle with empty aisle
//    func testInsertAisleWithEmptyAisleThrowsError() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        
//        // When
//        let _ = try await medicineStockViewModel.insertAisle(name: "fakeName", stock: 55, aisle: "")
//        
//        // Then
//        XCTAssertEqual(medicineStockViewModel.messageEror, "Please select a category to proceed.")
//    }
//    
//    // Test inserting aisle throws an error
//    func testInsertAisleThrowsError() async throws {
//        // Given
//        let mockMedicineServiceViewModel = MockMedicineServiceViewModel()
//        let medicineStockViewModel = MedicineStockViewModel(medicineRepository: mockMedicineServiceViewModel)
//        mockMedicineServiceViewModel.shouldThrowError = true
//        
//        // When/Then
//        do {
//            let _ = try await medicineStockViewModel.insertAisle(name: "fakeName", stock: 0, aisle: "A7ZE")
//            XCTFail("Expected error, but the operation succeeded.")
//        } catch let error {
//            XCTAssertEqual(error as? ThrowsErrorReason, ThrowsErrorReason.insertAisleThrowsError)
//            XCTAssertEqual(medicineStockViewModel.messageEror, "An error occurred while adding a new medicine. Please check that it is not already present.")
//        }
//    }
//    
//    // More tests for other cases can follow the same pattern.
//}
//
