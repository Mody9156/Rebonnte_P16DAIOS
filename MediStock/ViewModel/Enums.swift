//
//  Enums.swift
//  pack
//
//  Created by Modibo on 13/03/2025.
//

import Foundation

enum TypeOF: Identifiable {
    case TypeOne(SelectNameOfMedicineListAnalgesics_andAntiInflammatory)
    case TypeTwo(SelectNameOfMedicineListAntibioticsAndAntibacterials)
    case TypeThree(SelectNameOfMedicineListAntituberculosisAndAntileprosy)
    case TypeFour(SelectNameOfMedicineListDermatology)
    case TypeFive(SelectNameOfMedicineOncology)
    
    
    var id: String {
            switch self {
            case .TypeOne(let medicine):
                return medicine.rawValue
            case .TypeTwo(let medicine):
                return medicine.rawValue
            case .TypeThree(let medicine):
                return medicine.rawValue
            case .TypeFour(let medicine):
                return medicine.rawValue
            case .TypeFive(let medicine):
                return medicine.rawValue
            }
        }

        var displayName: String {
            switch self {
            case .TypeOne(let medicine):
                return medicine.rawValue
            case .TypeTwo(let medicine):
                return medicine.rawValue
            case .TypeThree(let medicine):
                return medicine.rawValue
            case .TypeFour(let medicine):
                return medicine.rawValue
            case .TypeFive(let medicine):
                return medicine.rawValue
            }
        }
}
enum SelectedAisles: String, CaseIterable, Identifiable {
    
    case Analgesics = "Analgesics and Anti-inflammatory drugs"
    case Antibiotics = "Antibiotics and Antibacterials"
    case AntituberculosisAndAntileprosy = "Antituberculosis and Antileprosy drugs"
    case Dermatology = "Dermatology"
    case Oncology = "Oncology"
//    case Antituberculosi = "Antituberculosis drugs"
    
    var id: String  { self.rawValue }
}

enum SelectNameOfMedicineListAnalgesics_andAntiInflammatory: String, CaseIterable, Identifiable {
    
    case Peripherally = "Peripherally acting analgesics"
    case Centrally = "Centrally acting analgesics"
    case NonSteroidal = "Non-Steroidal Anti-Inflammatory Drugs (NSAIDs)"
    case Steroidal = "Steroidal Anti-Inflammatory Drugs (Corticosteroids)"
    
    var id: String  { self.rawValue }
}

enum SelectNameOfMedicineListAntibioticsAndAntibacterials: String, CaseIterable, Identifiable {
    
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


enum SelectNameOfMedicineListAntituberculosisAndAntileprosy: String, CaseIterable, Identifiable {
    
    case Antituberculosis = "Antituberculosis drugs"
    case Topical = "Topical antibiotics in dermatology"
    
    var id: String  { self.rawValue }
}

enum SelectNameOfMedicineListDermatology: String, CaseIterable, Identifiable {
    
    case Anti = "Anti-acne drugs"
    case Antileprosy = "Antileprosy drugs"
    case dermatology = "Topical antivirals in dermatology: Antiherpetic drugs"
    var id: String  { self.rawValue }
}


enum SelectNameOfMedicineOncology: String, CaseIterable, Identifiable {
    
    case Antimetabolites = "Antimetabolites"
    case Alkylating  = "Alkylating agents"
    case Tubulin = "Tubulin-interacting drugs"
    case Intercalating = "Intercalating agents"
    var id: String  { self.rawValue }
}
