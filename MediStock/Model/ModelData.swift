//
//  ModelData.swift
//  pack
//
//  Created by Modibo on 19/03/2025.
//

import Foundation

struct ModelData {
    static func chargement<T: Decodable>(_ nomFichier: String) -> T {//fonctions génériques
        let data: Data
        
        guard let file = Bundle.main.url(forResource: nomFichier, withExtension: nil)
        else {
            nil
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            nil
        }
    }
}
