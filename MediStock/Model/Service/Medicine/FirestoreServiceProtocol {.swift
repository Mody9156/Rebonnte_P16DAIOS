//
//  FirebaseMedicineService.swift
//  pack
//
//  Created by KEITA on 29/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseMedicineService : CollectionReferenceProtocol {
    var collectionReference :  CollectionReference
    
    init(collectionReference :  CollectionReference){
        self.collectionReference =  collectionReference
    }
    
    func addSnapshotListener(_ listener: @escaping (QuerySnapshotProtocol?, Error?) -> Void) {
        collectionReference.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot {
                listener(FirestoreQuerySnapshotAdapter(snapshot: snapshot), error)
            } else {
                listener(nil, error)
            }
        }
    }
    
    func order(by field: String, descending: Bool) -> Query {
        
    }
    
}
