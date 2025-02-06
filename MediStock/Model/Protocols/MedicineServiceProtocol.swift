//
//  MedicineServiceProtocol.swift
//  pack
//
//  Created by KEITA on 29/01/2025.
//

import Foundation
import FirebaseFirestore

// Protocole pour CollectionReference
protocol CollectionReferenceProtocol {
    func addSnapshotListener(_ listener: @escaping (QuerySnapshotProtocol?, Error?) -> Void)
}

// Protocole pour QuerySnapshot
protocol QuerySnapshotProtocol {
    var documents: [QueryDocumentSnapshotProtocol] { get }
}

// Protocole pour QueryDocumentSnapshot
protocol QueryDocumentSnapshotProtocol {
    var data : [String: Any] {get}
    func asMedicine() -> Medicine?
    func asHistory() -> HistoryEntry?
    func documents(documentPath:String) -> DocumentReference
    func whereField(field:String,isEqualTo value: Any) -> CollectionReferenceProtocol
    func order(by field: String, descending: Bool) -> CollectionReferenceProtocol

}

protocol QueryProtocol {
    func addSnapshotListener(_ listener: @escaping (QuerySnapshotProtocol?, Error?) -> Void)
}

protocol FirestoreServiceProtocol {
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
}
