//
//  Enums.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import Foundation

enum TypeOF: Identifiable {
    case TypeOne(SelectNameOfMedicineList)
    case TypeTwo(SelectNameOfMedicineListTwo)
    
    var id: String {
            switch self {
            case .TypeOne(let medicine):
                return medicine.rawValue
            case .TypeTwo(let medicine):
                return medicine.rawValue
            }
        }

        var displayName: String {
            switch self {
            case .TypeOne(let medicine):
                return medicine.rawValue
            case .TypeTwo(let medicine):
                return medicine.rawValue
            }
        }
}
enum SelectAisleList: String, CaseIterable, Identifiable {
    
    case Analgesics = "Analgesics and Anti-inflammatory drugs"
    case Antibiotics = "Antibiotics and Antibacterials"
//    case Antituberculosi = "Antituberculosis drugs"
    
    var id: String  { self.rawValue }
}

enum SelectNameOfMedicineList: String, CaseIterable, Identifiable {
    
    case Peripherally = "Peripherally acting analgesics"
    case Centrally = "Centrally acting analgesics"
    case NonSteroidal = "Non-Steroidal Anti-Inflammatory Drugs (NSAIDs)"
    case Steroidal = "Steroidal Anti-Inflammatory Drugs (Corticosteroids)"
    
    var id: String  { self.rawValue }
}

enum SelectNameOfMedicineListTwo: String, CaseIterable, Identifiable {
    
    case Beta = "Beta-lactams"
    case Aminoglycosides = "Aminoglycosides"
    case Macrolides = "Macrolides and related compounds"
    case Antibiotics = "Antibiotics with retained antistaphylococcal activity"
    case Tetracyclines = "Tetracyclines (Cyclines)"
    case casePhenicols = "casePhenicols"
    case Cyclic = "Cyclic polypeptides (Polymyxins)"
    case Sulfonamides = "Sulfonamides and Diaminopyrimidines"
    case Quinolones = "Quinolones"
    case Nitroimidazole = "Nitroimidazole derivatives"
    case Miscellaneous = "Miscellaneous antibiotics"
    case antibacterials =  "antibacterials"
    
    var id: String  { self.rawValue }
}
