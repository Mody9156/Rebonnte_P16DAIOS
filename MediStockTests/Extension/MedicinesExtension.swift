//
//  MedicinesExtension.swift
//  MediStockTests
//
//  Created by Modibo on 24/03/2025.
//

import Foundation
@testable import pack


extension pack.Medicine {
    static var testMEdicine: Medicine{
        return Medicine(name: "Doliprane", stock: 10, aisle: "A2")
    }
    
    static var emptyStockMedicine: Medicine {
        return Medicine(name: "Ibuprofen", stock: 0, aisle: "B1")
    }
}
