//
//  FirestoreQuerySnapshotAdapter.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation
import Firebase

class FirestoreQuerySnapshotAdapter: QuerySnapshotProtocol {
    var snapshot: QuerySnapshot
    var collectionReference: CollectionReference

    init(snapshot: QuerySnapshot, collectionReference: CollectionReference) {
        self.snapshot = snapshot
        self.collectionReference = collectionReference
    }
    
    var documents: [QueryDocumentSnapshotProtocol]{
        return snapshot.documents.map{FirestoreQueryDocumentAdapter(document: $0, collectionReference: collectionReference)}
    }
    
}
