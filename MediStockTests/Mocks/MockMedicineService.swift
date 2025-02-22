////
////  MockMedicineService.swift
////  MediStockTests
////
////  Created by KEITA on 29/01/2025.
////
//import XCTest
//@testable import pack
//import FirebaseFirestore
//
//// Mock du service Firestore
//class MockFirestore {
//    var mockCollection: MockCollectionReference
//
//    init(mockCollection: MockCollectionReference) {
//        self.mockCollection = mockCollection
//    }
//
//    func collection(_ collectionPath: String) -> MockCollectionReference {
//        return mockCollection
//    }
//}
//
//// Mock du service Firestore
//class MockMedicineService: FirestoreServiceProtocol {
//    var collectionPath: String?
//    var mockDocuments: [QueryDocumentSnapshotProtocol] = []
//
//    init(collection: String? = nil, mockDocuments: [QueryDocumentSnapshotProtocol] = []) {
//        self.collectionPath = collection
//        self.mockDocuments = mockDocuments
//    }
//
//    func collection(_ collectionPath: String) -> pack.CollectionReferenceProtocol {
//        self.collectionPath = collectionPath
//        return MockCollectionReference(mockDocuments: mockDocuments)
//    }
//}
//
//// Simule une collection Firestore
//class MockCollectionReference: CollectionReferenceProtocol {
//    var mockDocuments: [QueryDocumentSnapshotProtocol]
//
//    init(mockDocuments: [QueryDocumentSnapshotProtocol]) {
//        self.mockDocuments = mockDocuments
//    }
//
//    func getDocuments(completion: @escaping ([pack.QueryDocumentSnapshotProtocol]) -> Void) {
//        completion(mockDocuments)
//    }
//}
//
////
////Mock pour QuerDocumentSnapshot
//class MockQueryDocumentSnapshotProtocol: QueryDocumentSnapshotProtocol{
//    var data: [String : Any]
//      
//    init(data: [String : Any]){
//        self.data = data
//    }
//}
////
//////Mock pour QuerySnapshot
////class MockQuerySnapshot: QuerySnapshotProtocol{
////    var documents: [QueryDocumentSnapshotProtocol]
////
////    init(documents: [QueryDocumentSnapshotProtocol]) {
////        self.documents = documents
////    }
////}
////
//////Mock pour CollectionReference
////class MockCollectionReference: CollectionReferenceProtocol{
////    private var mockDocuments: [QueryDocumentSnapshotProtocol]
////
////    init(mockDocuments: [QueryDocumentSnapshotProtocol]) {
////        self.mockDocuments = mockDocuments
////    }
////
////    func addSnapshotListener(_ listener: @escaping (QuerySnapshotProtocol?, Error?) -> Void) -> ListenerRegistration {
////        let snapshot = MockQuerySnapshot(documents: mockDocuments)
////        listener(snapshot, nil)
////        return MockListenerRegistration()
////    }
////
////
////}
////
//////Mock pour ListenerRegistration
////class MockListenerRegistration: NSObject, ListenerRegistration {
////    func remove(){
////        // Implémentation vide pour le mock
////    }
////}
//////class FirestoreServiceTests {
//////    func testFetchData() {
//////        // Données mock
//////        let mockData: [String: Any] = ["name": "Test Item", "value": 42]
//////        let mockDocument = MockQueryDocumentSnapshot(data: mockData, documentID: "abc123")
//////        let mockCollection = MockCollectionReference(documents: [mockDocument])
//////
//////        // Utilisez mockCollection dans vos tests
//////        mockCollection.addSnapshotListener { snapshot, error in
//////            guard let snapshot = snapshot else {
//////                // Gérer l'erreur
//////                return
//////            }
//////
//////            for document in snapshot.documents {
//////                let data = document.data()
//////                // Testez les données
//////                print(data)
//////            }
//////        }
//////    }
//////}
