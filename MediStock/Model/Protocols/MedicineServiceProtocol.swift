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
    func getDocuments(completion: @escaping ([QueryDocumentSnapshotProtocol]) -> Void)
}

// Protocole pour QuerySnapshot
protocol QuerySnapshotProtocol {
    var documents: [QueryDocumentSnapshotProtocol] { get }
}

// Protocole pour QueryDocumentSnapshot
protocol QueryDocumentSnapshotProtocol {
    var data : [String: Any] {get}
}

protocol FirestoreServiceProtocol {
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
}
