import Foundation
import Firebase


class MedicineStockViewModel: ObservableObject {
    enum FilterOption: String, CaseIterable {
        case noFilter
        case name
        case stock
    }
    
    @Published var filterOption : FilterOption? = .noFilter
    @Published var medicines: [Medicine]
    @Published var aisles: [String] = []
    @Published var history: [HistoryEntry] = []
    @Published var medicineRepository = MedicineRepository()
    @Published var showErrorAlert : Bool = false
    @Published var errorMessage : String = ""
    
    init(medicines: [Medicine] = MedicineRepository().medicines) {
        self.medicines = medicines
    }
    
    func observeMedicines() {
        self.medicineRepository.fetchMedicines{ [weak self]  medicines in
              self? .medicines = medicines
        }
    }
    
    func observeAisles() {
        medicineRepository.fetchAisles { [weak self]  aisles in
                self?.aisles = aisles
        }
    }
    
    func addRandomMedicine(user: String) async throws {
            try await medicineRepository.setData(user: user)
    }
    
    func addRandomMedicineToList(user: String, aisle: String) async throws {
        try await medicineRepository.setDataToList(user: user, aisle: aisle)
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
    
    func changeStock(_ medicine: Medicine, user: String, stocks:Int) {
            self.updateStock(medicine, by: stocks, user: user)
    }
    
    private func updateStock(_ medicine: Medicine, by amount: Int, user: String) {
            self.medicineRepository.updateStock(medicine, by: amount, user: user)
    }
    
    func increaseStock(_ medicine: Medicine, user: String) {
            self.updateStock(medicine, by: 1, user: user)
    }
    
    func decreaseStock(_ medicine: Medicine, user: String) {
        DispatchQueue.global(qos: .background).async{
            self.updateStock(medicine, by: -1, user: user)
        }
    }
    
    func updateMedicine(_ medicine: Medicine, user: String) async throws {
        try await medicineRepository.updateMedicine(medicine, user: user)
    }
    
    func fetchHistory(for medicine: Medicine) {
           self.medicineRepository.fetchHistory(for: medicine){history in
                    self.history = history
                    print("history : \(history)")
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
