//
//  MedicineRepositoryTests.swift
//  MediStockTests
//
//  Created by Modibo on 24/03/2025.
//
import Testing
@testable import pack
import XCTest
struct MedicineRepositoryTests {

    @Test func fetchMedicinesReturnsValidData() async throws {
        //Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
        //When/Then
        await #expect(throws: Never.self) {
           let user = try await  medicineRepository.fetchMedicines()
            #expect(!user.isEmpty)
        }
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func fetchMedicinesReturnsEmptyData() async throws {
        //Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
        mockMedicineService.showErrors = true
        //When
        await #expect(throws:  MedicineError.medicineIsEmpty) {
            let medicine = try await  medicineRepository.fetchMedicines()
            #expect(medicine == [])
        }
    }
    
    @Test
    func fetchAislesNoThrowError() async throws {
        //Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
        //When/Then
        
        await #expect(throws: Never.self){
          let medicine = try await  medicineRepository.fetchAisles()
            #expect(!medicine.isEmpty)
        }
    }
    
    @Test func fetAislesReturnsEmptyData() async throws {
        //Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
        mockMedicineService.showErrors = true
        //When/Then
         #expect(throws:  MedicineError.aisleIsEmpty) {
            let user = try await  medicineRepository.fetchAisles()
             #expect(user == [])
        }
    }
}
