import Foundation
import Firebase


class MedicineStockViewModel: ObservableObject {
    enum FilterOption: String, CaseIterable {
        case noFilter
        case name
        case stock
    }
    
    enum ThrowsErrorReason: Error {
        case addRandomAisleThrowsError
        case insertAisleThrowsError
        case insertMedicineToListThrowError
        case deleteMedicinesThrowsError
        case deleteAisleThrowsError
        case changeStockThrowsError
        case updateStockThrowsError
        case updateMedicineThrowsError
    }
//    MedicineProtocol
    @Published var filterOption : FilterOption? = .noFilter
    @Published var medicines: [Medicine]
    @Published var aisles: [String] = []
    @Published var history: [HistoryEntry] = []
    @Published var medicineRepository = MedicineRepository()
    @Published var messageEror : String? = nil
//    MedicineRepository()
    @Published var medicineListed: MedicationsData? = ModelData.chargement("Source.json")
    
    init(medicines: [Medicine] = MedicineRepository().medicines) {
        self.medicines = medicines
        
    }
    
    func observeMedicines() async throws {
        do{
            let medicine = try await medicineRepository.fetchMedicines()
            medicines = medicine
        }catch{
            throw MedicineError.medicineIsEmpty
        }
    }
    
    func observeAisles() async throws {
        do{
            let medicine =  try await medicineRepository.fetchAisles()
            aisles = medicine
        }catch{
            throw MedicineError.aisleIsEmpty
        }
    }
    
    @MainActor
    func insertAisle(name: String, stock: Int, aisle: String) async throws {
        
        guard aisle.isEmpty == false else {
            return messageEror = "Please select a category to proceed."
        }
        
        guard name.isEmpty == false else {
            return messageEror = "Please enter the medicine name."
        }
        
        do{
            let _ = try await medicineRepository.setDataToAisle(name: name, stock: stock, aisle: aisle)
            messageEror = nil
        }catch{
            messageEror = "An error occurred while adding a new medicine. Please check that it is not already present."
            throw ThrowsErrorReason.insertAisleThrowsError
        }
    }
    
    @MainActor
    func insertMedicineToList(user: String,name:String, stock:Int, aisle:String, stockValue:Int) async throws {
        guard aisle.isEmpty == false else {
            return messageEror = "Please select a category to proceed."
        }
        
        guard name.isEmpty == false else {
            return messageEror = "Please enter the medicine name."
        }
        
        do{
            let _ = try await medicineRepository.setDataToList(user: user,name:name, stock:stock, aisle:aisle, stockValue: stockValue)
            messageEror = nil
        }catch{
            messageEror = "An error occurred while adding a new medicine. Please check that it is not already present."
            throw ThrowsErrorReason.insertMedicineToListThrowError
        }
    }
    
    func deleteMedicines(at offsets: IndexSet) async throws {
        do{
            try await  medicineRepository.delete(medicines: medicines, at: offsets)
        }catch{
            throw  ThrowsErrorReason.deleteMedicinesThrowsError
        }
    }
    
    func deleteAisle(at offsets: IndexSet) async throws {
        do{
            let updateAisle = try await  medicineRepository.deleteAisle(aisles:self.aisles,at: offsets)
            await MainActor.run {
                self.aisles = updateAisle
            }
        }catch{
            throw  ThrowsErrorReason.deleteMedicinesThrowsError
        }
    }
    
    func changeStock(_ medicine: Medicine, user: String, stocks:Int,stockValue:Int) async throws {
        do{
            try await updateStock(medicine, by: stocks, user: user, stock: stockValue)
        }catch{
            throw  ThrowsErrorReason.changeStockThrowsError
        }
    }
    
    private func updateStock(_ medicine: Medicine, by amount: Int, user: String, stock:Int) async throws {
        do{
            try await medicineRepository.updateStock(medicine, by: amount, user: user, stock: stock)
        }catch{
            throw  ThrowsErrorReason.updateStockThrowsError
        }
    }
    
    func updateMedicine(_ medicine: Medicine, user: String,stock:Int) async throws {
        do{
            try await medicineRepository.updateMedicine(medicine, user: user, stock: stock)
        }catch{
            throw  ThrowsErrorReason.updateMedicineThrowsError
        }
    }
    
    func fetchHistory(for medicine: Medicine) {
        self.medicineRepository.fetchHistory(for: medicine){history in
            self.history = history
        }
    }
    
    //    func triByName(){
    //        medicineRepository.trieByName { medicines in
    //            self.medicines = medicines
    //        }
    //    }
    
    @MainActor
    func trieElements(option:FilterOption) async throws {
        
        self.filterOption = option
        
        switch option{
        case .noFilter :
            medicineRepository.getAllElements{ medicines in
                self.medicines = medicines
            }
        case .name :
            medicineRepository.trieByName { medicines in
                self.medicines = medicines
            }
        case .stock :
            medicineRepository.trieByStock { medicines in
                self.medicines = medicines
            }
        }
    }
}
