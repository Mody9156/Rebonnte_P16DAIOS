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
    }
    
    @Published var filterOption : FilterOption? = .noFilter
    @Published var medicines: [Medicine]
    @Published var aisles: [String] = []
    @Published var history: [HistoryEntry] = []
    @Published var medicineRepository = MedicineRepository()
    @Published var messageEror : String? = nil
    
    init(medicines: [Medicine] = MedicineRepository().medicines) {
        self.medicines = medicines
    }
    
    func observeMedicines()  {
        self.medicineRepository.fetchMedicines{ [weak self]  medicines in
            self?.medicines = medicines
        }
    }
    
    func observeAisles() {
        medicineRepository.fetchAisles { [weak self]  aisles in
            self?.aisles = aisles
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
    
    //    func addRandomMedicine(user: String) async throws {
    //
    //        do{
    //            try await medicineRepository.setData(user: user)
    //
    //        }catch{
    ////            throw ThrowsErrorReason.addRandomMedicineThrowError
    //        }
    //    }
    //
    @MainActor
    func insertMedicineToList(user: String,name:String, stock:Int, aisle:String) async throws {
        guard aisle.isEmpty == false else {
            return messageEror = "Please select a category to proceed."
        }
        
        guard name.isEmpty == false else {
            return messageEror = "Please enter the medicine name."
        }
        
        do{
            try await medicineRepository.setDataToList(user: user,name:name, stock:stock, aisle:aisle)
            messageEror = nil
        }catch{
            messageEror = "An error occurred while adding a new medicine. Please check that it is not already present."
            throw ThrowsErrorReason.insertMedicineToListThrowError
        }
    }
    
    func deleteMedicines(at offsets: IndexSet) async throws {
        try await  medicineRepository.delete(medicines: medicines, at: offsets)
    }
    
    func deleteAisle(at offsets: IndexSet) async throws {
        do{
            let updateAisle = try await  medicineRepository.deleteAisle(aisles:self.aisles,at: offsets)
            await MainActor.run {
                self.aisles = updateAisle
            }
        }catch{
            print("erreur lors de la suppression")
        }
        
    }
    
    func changeStock(_ medicine: Medicine, user: String, stocks:Int) async throws {
        try await updateStock(medicine, by: stocks, user: user)
    }
    
    private func updateStock(_ medicine: Medicine, by amount: Int, user: String) async throws {
        try await medicineRepository.updateStock(medicine, by: amount, user: user)
    }
    
    func increaseStock(_ medicine: Medicine, user: String) async throws {
        try await updateStock(medicine, by: 1, user: user)
    }
    
    func decreaseStock(_ medicine: Medicine, user: String) async throws {
        try await updateStock(medicine, by: -1, user: user)
    }
    
    func updateMedicine(_ medicine: Medicine, user: String) async throws {
        try await medicineRepository.updateMedicine(medicine, user: user)
    }
    
    func fetchHistory(for medicine: Medicine) {
        self.medicineRepository.fetchHistory(for: medicine){history in
            self.history = history
        }
    }
    
    func triByName(){
        medicineRepository.trieByName { medicines in
            self.medicines = medicines
        }
    }
    
    @MainActor
    func trieElements(option:FilterOption) async throws {
        
        self.filterOption = option
        
        switch option{
        case .noFilter :
            medicineRepository.getAllElements{ medicines in
                self.medicines = medicines
                print("Produits récupérés sans filtre. Nombre de produits : \(self.medicines.count)")
                print("Données : \(self.medicines)")  // Affiche les données récupérées
            }
        case .name :
            medicineRepository.trieByName { medicines in
                self.medicines = medicines
                print("Produits récupérés sans filtre. Nombre de produits : \(self.medicines.count)")
                print("Données : \(self.medicines)")  // Affiche les données récupérées
            }
        case .stock :
            medicineRepository.trieByStock { medicines in
                self.medicines = medicines
                print("Produits récupérés sans filtre. Nombre de produits : \(self.medicines.count)")
                print("Données : \(self.medicines)")  // Affiche les données récupérées
            }
        }
    }
}
