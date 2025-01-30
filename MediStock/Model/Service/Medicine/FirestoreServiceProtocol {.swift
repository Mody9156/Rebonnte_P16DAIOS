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
    
    func getDocuments(completion: @escaping ([QueryDocumentSnapshotProtocol]) -> Void) {
        collectionReference.getDocuments { query, error in
            guard let document = query?.documents else {
                completion([])
                return
            }
            let addDocuments = document.map{ FirestoreQueryDocumentAdapter(document.$0) }
            completion(addDocuments)
        }
    }
}
