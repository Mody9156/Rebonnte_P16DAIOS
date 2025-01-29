//
//  MockMedicineService.swift
//  MediStockTests
//
//  Created by KEITA on 29/01/2025.
//
import XCTest
@testable import pack
import FirebaseFirestore

class MockMedicineService: Firestore {
    var collection: String? = nil
    var mockDocuments: [QueryDocumentSnapshotProtocol] = []
    
    func collection(_ collectionPath: String) -> QueryDocumentSnapshotProtocol {
        collection = collectionPath
        return MockCollectionReference(mockDocuments: mockDocuments) as! QueryDocumentSnapshotProtocol
    }
}

//Mock pour QuerDocumentSnapshot
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

//Mock pour QuerySnapshot
class MockQuerySnapshot: QuerySnapshotProtocol{
    var documents: [QueryDocumentSnapshotProtocol]
    
    init(documents: [QueryDocumentSnapshotProtocol]) {
        self.documents = documents
    }
}

//Mock pour CollectionReference
class MockCollectionReference: CollectionReferenceProtocol{
    private var mockDocuments: [QueryDocumentSnapshotProtocol]
    
    init(mockDocuments: [QueryDocumentSnapshotProtocol]) {
        self.mockDocuments = mockDocuments
    }
    
    func addSnapshotListener(_ listener: @escaping (QuerySnapshotProtocol?, Error?) -> Void) -> ListenerRegistration {
        let snapshot = MockQuerySnapshot(documents: mockDocuments)
        listener(snapshot, nil)
        return MockListenerRegistration()
    }
    
    
}

//Mock pour ListenerRegistration
class MockListenerRegistration: NSObject, ListenerRegistration {
    func remove(){
        // Implémentation vide pour le mock
    }
}
//class FirestoreServiceTests {
//    func testFetchData() {
//        // Données mock
//        let mockData: [String: Any] = ["name": "Test Item", "value": 42]
//        let mockDocument = MockQueryDocumentSnapshot(data: mockData, documentID: "abc123")
//        let mockCollection = MockCollectionReference(documents: [mockDocument])
//
//        // Utilisez mockCollection dans vos tests
//        mockCollection.addSnapshotListener { snapshot, error in
//            guard let snapshot = snapshot else {
//                // Gérer l'erreur
//                return
//            }
//
//            for document in snapshot.documents {
//                let data = document.data()
//                // Testez les données
//                print(data)
//            }
//        }
//    }
//}
