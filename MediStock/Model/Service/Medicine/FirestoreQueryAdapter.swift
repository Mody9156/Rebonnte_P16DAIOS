//
//  FirestoreQueryAdapter.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreQueryAdapter: CollectionReferenceProtocol {
    let query: Query
    var collectionReference :  CollectionReference
    
    init(query: Query, collectionReference :  CollectionReference){
        self.query = query
        self.collectionReference = collectionReference
    }
    
    func addSnapshotListener(_ listener: @escaping (QuerySnapshotProtocol?, Error?) -> Void) {
        query.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot {
                listener(FirestoreQuerySnapshotAdapter(snapshot: snapshot, collectionReference: self.collectionReference),error)
            } else {
                listener(nil,error)
            }
        }
    }
}
