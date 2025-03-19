//
//  ModelData.swift
//  pack
//
//  Created by Modibo on 19/03/2025.
//

import Foundation

struct ModelData {
    static func chargement<T: Decodable>(_ nomFichier: String) -> T? {//fonctions génériques
        let data: Data
        
        guard let file = Bundle.main.url(forResource: nomFichier, withExtension: nil)
        else {
            print("Impossible de trouver \(nomFichier) dans le main bundle.")
            return nil
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            print("Impossible de charger \(nomFichier) depuis le main bundle:\n\(error)")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Impossible de parser \(nomFichier) en tant que \(T.self):\n\(error)")
            return nil
        }
    }
}
