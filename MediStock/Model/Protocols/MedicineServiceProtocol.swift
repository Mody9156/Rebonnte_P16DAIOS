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
    func addSnapshotListener(_ listener: @escaping (QuerySnapshot?, Error?) -> Void) -> ListenerRegistration
}

// Protocole pour QuerySnapshot
protocol QuerySnapshotProtocol {
    var documents: [QueryDocumentSnapshot] { get }
}

// Protocole pour QueryDocumentSnapshot
protocol QueryDocumentSnapshotProtocol {
    func data() -> [String: Any]
    var documentID: String { get }
}
