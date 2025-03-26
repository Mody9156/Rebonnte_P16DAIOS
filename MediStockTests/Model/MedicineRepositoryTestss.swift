//
//  MedicineRepositoryTestss.swift
//  MediStockTests
//
//  Created by Modibo on 26/03/2025.
//

import XCTest
@testable import pack

class MedicineRepositoryTestss: XCTestCase {

    // Test 1
    func testFetchMedicinesReturnsValidData() async throws {
        // Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService: mockMedicineService)

        // Create an expectation for async call
        let expectation = expectation(description: "Fetching medicines")
        
        // When
        do {
            let medicines = try await medicineRepository.fetchMedicines()
            XCTAssertFalse(medicines.isEmpty) // Ensure we have some medicines
            expectation.fulfill() // Fulfill expectation when test is done
        } catch {
            XCTFail("Expected to fetch medicines but failed with error: \(error)")
        }
        
        // Use the new 'await' method for async expectations
        await fulfillment(of: [expectation], timeout: 5)
    }

    // Test 2
    func testFetchMedicinesReturnsEmptyData() async throws {
        // Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService: mockMedicineService)
        mockMedicineService.showErrors = true // Force error condition

        // Create an expectation
        let expectation = expectation(description: "Fetching empty medicines data")
        
        // When
        do {
            let medicines = try await medicineRepository.fetchMedicines()
            XCTAssertTrue(medicines.isEmpty) // Ensure medicines are empty
            expectation.fulfill()
        } catch {
            XCTAssertEqual(error as? MedicineError, MedicineError.medicineIsEmpty)
            expectation.fulfill() // Fulfill expectation when error is caught
        }
        
        // Use the new 'await' method for async expectations
        await fulfillment(of: [expectation], timeout: 5)
    }

    // Test 3
    func testSetDataToListNoThrowErrors() async throws {
        // Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService: mockMedicineService)

        // Create an expectation
        let expectation = expectation(description: "Setting data to list")

        // When
        do {
            let result = try await medicineRepository.setDataToList(
                user: "fake",
                name: "Doliprane",
                stock: 10,
                aisle: "A2",
                stockValue: 10
            )
            XCTAssertTrue(result.count > 0) // Expect some result
            expectation.fulfill()
        } catch {
            XCTFail("Expected no error but failed with error: \(error)")
        }
        
        // Use the new 'await' method for async expectations
        await fulfillment(of: [expectation], timeout: 5)
    }

    // Test 4
    func testSetDataToListThrowsError() async throws {
        // Given
        let mockMedicineService = MockMedicineService()
        mockMedicineService.showErrors = true
        let medicineRepository = MedicineRepository(medicineService: mockMedicineService)

        // Create an expectation
        let expectation = expectation(description: "Setting data to list throws error")
        
        // When
        do {
            _ = try await medicineRepository.setDataToList(
                user: "",
                name: "Unknown",
                stock: 5,
                aisle: "Z9",
                stockValue: 5
            )
            XCTFail("Expected error but no error thrown")
        } catch let error as MedicineError {
            XCTAssertEqual(error, MedicineError.invalidSetData) // Expect specific error
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        // Use the new 'await' method for async expectations
        await fulfillment(of: [expectation], timeout: 5)
    }

    // Test 5
    func testDeleteRightAisleNoThrowError() async throws {
        // Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService: mockMedicineService)
        let deleteIndexes = IndexSet([1])
        let initialCount = mockMedicineService.testMedicines.count
        
        // Create an expectation
        let expectation = expectation(description: "Deleting medicines from aisle")

        // When
        do {
            try await medicineRepository.delete(
                medicines: mockMedicineService.testMedicines,
                at: deleteIndexes
            )
            XCTAssertEqual(mockMedicineService.testMedicines.count, initialCount - 1) // Validate deletion
            expectation.fulfill()
        } catch {
            XCTFail("Expected no error but failed with error: \(error)")
        }

        // Use the new 'await' method for async expectations
        await fulfillment(of: [expectation], timeout: 5)
    }

    // Test 6
    func testDeleteBadIndexThrowsError() async throws {
        // Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService: mockMedicineService)
        mockMedicineService.showErrors = true
        let deleteIndexes = IndexSet([0])
        
        // Create an expectation
        let expectation = expectation(description: "Deleting medicines with invalid index")
        
        // When
        do {
            _ = try await medicineRepository.delete(
                medicines: mockMedicineService.testMedicines,
                at: deleteIndexes
            )
            XCTFail("Expected error but no error thrown")
        } catch let error as MedicineError {
            XCTAssertEqual(error, MedicineError.invalidDelete) // Expect specific error
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        // Use the new 'await' method for async expectations
        await fulfillment(of: [expectation], timeout: 5)
    }
}
