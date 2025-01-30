//
//  FirestoreQuerySnapshotAdapter.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation
import Firebase

class FirestoreQuerySnapshotAdapter: QuerySnapshotProtocol {
    
    let snapshot: QuerySnapshot
    
    init(snapshot: QuerySnapshot) {
        self.snapshot = snapshot
    }
    
    var documents: [QueryDocumentSnapshotProtocol]{
        return snapshot.documents.map{FirestoreQueryDocumentAdapter(document: $0)}
    }
    
}
