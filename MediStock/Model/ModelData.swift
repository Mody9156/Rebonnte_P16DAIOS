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
            fatalError("Impossible de trouver \(nomFichier) dans le main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Impossible de charger \(nomFichier) depuis le main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Impossible de parser \(nomFichier) en tant que \(T.self):\n\(error)")
        }
    }
}
