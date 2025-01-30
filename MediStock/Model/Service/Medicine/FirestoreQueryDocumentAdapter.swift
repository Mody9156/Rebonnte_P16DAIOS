//
//  FirestoreQueryDocumentAdapter.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation

class FirestoreQueryDocumentAdapter : QueryDocumentSnapshotProtocol {
    let snapshot: QuerySnapshot

        init(snapshot: QuerySnapshot) {
            self.snapshot = snapshot
        }

        var documents: [String: Any] {
            return snapshot.documents.map { QuerySnapshotProtocol(document: $0) }
        }
    
}
