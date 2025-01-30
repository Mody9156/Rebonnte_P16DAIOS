//
//  ExtensionFirestore.swift
//  pack
//
//  Created by KEITA on 30/01/2025.
//

import Foundation
import Firebase

extension Firestore: FirestoreServiceProtocol {
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return self.Collection(collectionPath) as CollectionReference
    }
}
