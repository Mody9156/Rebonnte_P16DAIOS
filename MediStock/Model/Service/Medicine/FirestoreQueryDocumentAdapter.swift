//
//  FirestoreQueryDocumentAdapter.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation
import Firebase

class FirestoreQueryDocumentAdapter : QueryDocumentSnapshotProtocol {
    private var document : QueryDocumentSnapshot
    
    init(document : QueryDocumentSnapshot){
        self.document = document
    }
    
    var data: [String : Any]{
        return document.data()
    }
}
