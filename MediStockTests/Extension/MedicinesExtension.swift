//
//  MedicinesExtension.swift
//  MediStockTests
//
//  Created by Modibo on 24/03/2025.
//

import Foundation
@testable import pack


extension pack.Medicine {
    static var testMedicine: [Medicine]{
        return [Medicine(name: "Doliprane", stock: 10, aisle: "A2")]
    }
    
    static var emptyStockMedicine: [Medicine] {
        return [Medicine(name: "Ibuprofen", stock: 0, aisle: "B1")]
    }
    
    static var emptyMedicine: [Medicine] {
        return []
    }
}

extension pack.HistoryEntry {
    static var testHistoryEntry: [HistoryEntry]{
        return [HistoryEntry(medicineId: "fakeId", user: "Fake@gmail.com", action: "Update", details: "Change items", stock: 50)]
    }
    
    static var emptyHistoryEntry: [HistoryEntry] {
        return []
    }
}

extension pack.User {
    static var testUser: [User] {
        return [User(uid: "fakeUid", email: "fakeEmail@gmail.com")]
    }
    static var emptyUser: [User] {
        return []
    }
}
