//
//  MockMedicineService.swift
//  MediStockTests
//
//  Created by KEITA on 29/01/2025.
//
import XCTest
@testable import pack
import FirebaseFirestore

// MARK: - Mock Medicine Service
final class MockMedicineService {
 
}


class MockCollectionReferenceProtocol{
    
}

class MockQuerySnapshotProtocol{
    
}

class MockQueryDocumentSnapshotProtocol: QueryDocumentSnapshotProtocol{
    private var mockData : [String: Any]
    var documentID: String
    
    init(mockData: [String : Any], documentID: String) {
        self.mockData = mockData
        self.documentID = documentID
    }
    
    func data() -> [String : Any] {
        return mockData
    }
}
