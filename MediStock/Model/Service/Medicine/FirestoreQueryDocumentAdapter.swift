//
//  FirestoreQueryDocumentAdapter.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation
import Firebase

class FirestoreQueryDocumentAdapter : QueryDocumentSnapshotProtocol {
    var document: QueryDocumentSnapshot
    
    init(document: QueryDocumentSnapshot ) {
        self.document = document
    }
    
    
    var data: [String: Any] {
       return document.data()
    }
    
    func asMedicine() -> Medicine?{
        return try? document.data(as: Medicine.self)
    }
    
    func documents(documentPath:String) -> DocumentReference {
        let documentReferenc = Firestore.firestore().document(documentPath)
        return documentReferenc
    }
    
    func whereField(field:String,isEqualTo value: Any) {
        Firestore.firestore().collection("history").whereField(field, isEqualTo: value)
    }
}
//document(medicine.id ?? UUID().uuidString).setData(from: medicine)
