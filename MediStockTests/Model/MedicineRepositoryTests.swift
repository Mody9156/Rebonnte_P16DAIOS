//
//  MedicineRepositoryTests.swift
//  MediStockTests
//
//  Created by Modibo on 24/03/2025.
//

import Testing
@testable import pack
struct MedicineRepositoryTests {

    @Test func fetchMedicinesReturnsValidData() async throws {
        //Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
        //When/Then
        medicineRepository.fetchMedicines(completion: { medicine in
            for i in medicine {
                #expect(i.stock == 10)
                #expect(i.name == "Doliprane")
                #expect(i.aisle == "A2")
            }
        })
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func fetchMedicinesReturnsEmptyData() async throws {
        //Given
        let mockMedicineService = MockMedicineService()
        let medicineRepository = MedicineRepository(medicineService:mockMedicineService)
        mockMedicineService.showErrors = true
        //When/Then
        #expect(throws: MedicineError.medicineIsEmpty) {
            medicineRepository.fetchMedicines(completion: { medicine in
                for i in medicine {
                    #expect(i.name.isEmpty)
                    #expect(i.aisle.isEmpty)
                }
            })
        }
    }
}
