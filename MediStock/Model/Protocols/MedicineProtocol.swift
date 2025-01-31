//
//  MedicineProtocol.swift
//  pack
//
//  Created by KEITA on 31/01/2025.
//

import Foundation

protocol MedicineProtocol{
    func fetchMedicines(completion: @escaping ([Medicine]) -> Void)
    func fetchAisles(completion:@escaping( [String])->Void)
    func setData(user: String) async throws -> [Medicine]
    func setDataToList(user: String, aisle: String) async throws -> [Medicine]
    func delete(medicines: [Medicine], at offsets: IndexSet) async throws
    func updateMedicine(_ medicine: Medicine, user: String) async throws -> [Medicine]
    func updateStock(_ medicine: Medicine, by amount: Int, user: String)
    func fetchHistory(for medicine: Medicine, completion: @escaping([HistoryEntry])->Void)
    func trieByName(completion:@escaping([Medicine]) ->Void)
    func trieByStock(completion:@escaping([Medicine]) ->Void)
    func getAllElements(completion:@escaping([Medicine]) -> Void)
}
