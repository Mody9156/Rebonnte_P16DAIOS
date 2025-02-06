//
//  FirestoreQueryDocumentAdapter.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation
import Firebase

class FirestoreQueryDocumentAdapter : QueryDocumentSnapshotProtocol {
    private var collectionReference: CollectionReference
    var document: QueryDocumentSnapshot
    
    init(document: QueryDocumentSnapshot,collectionReference: CollectionReference) {
        self.document = document
        self.collectionReference = collectionReference
    }
    
    
    var data: [String: Any] {
       return document.data()
    }
    
    func asMedicine() -> Medicine?{
        return try? document.data(as: Medicine.self)
    }
    
    func asHistory() -> HistoryEntry? {
        return try? document.data(as: HistoryEntry.self)
    }
    
    func documents(documentPath:String) -> DocumentReference {
        let documentReferenc = Firestore.firestore().document(documentPath)
        return documentReferenc
    }
    
    func whereField(field:String,isEqualTo value: Any) -> CollectionReferenceProtocol {
        return FirestoreQueryAdapter(query: collectionReference.whereField(field, in: [value]), collectionReference: collectionReference)
    }
    func order(by field: String, descending: Bool) -> CollectionReferenceProtocol {
        return FirestoreQueryAdapter(query: collectionReference.order(by: field, descending: descending), collectionReference: collectionReference)
    }
}
