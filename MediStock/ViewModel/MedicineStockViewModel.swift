import Foundation
import Firebase

class MedicineStockViewModel: ObservableObject {
    @Published var medicines: [Medicine]
    @Published var aisles: [String] = []
    @Published var history: [HistoryEntry]
    @Published var medicineRepository = MedicineRepository()
    
    init(medicines: [Medicine] = MedicineRepository().medicines, history: [HistoryEntry] = MedicineRepository().history) {
        self.medicines = medicines
        self.history = history
    }
    
    func observeMedicines() {
        medicineRepository.fetchMedicines{ medicines in
            self.medicines = medicines
        }
    }
    
    func observeAisles() {
        medicineRepository.fetchAisles { aisles in
            self.aisles = aisles
        }
    }

    func addRandomMedicine(user: String) {
        medicineRepository.setData(user: user)
    }
    
    func deleteMedicines(at offsets: IndexSet) {
        medicineRepository.delete(medicines: medicines, at: offsets)
    }
    
    func increaseStock(_ medicine: Medicine, user: String) {
        DispatchQueue.global(qos:.background).async{
            self.updateStock(medicine, by: 1, user: user)
        }
    }
    
    func decreaseStock(_ medicine: Medicine, user: String) {
        DispatchQueue.global(qos:.background).async{
            self.updateStock(medicine, by: -1, user: user)
        }
    }
    
    private func updateStock(_ medicine: Medicine, by amount: Int, user: String) {
        DispatchQueue.global(qos:.background).async{
            self.medicineRepository.updateStock(medicine, by: amount, user: user)
        }
    }
    //created new Service
    func updateMedicine(_ medicine: Medicine, user: String) {
        DispatchQueue.global(qos:.background).async{
            self.medicineRepository.updateMedicine(medicine, user: user)
        }
    }
//    //created new Service
//    private func addHistory(action: String, user: String, medicineId: String, details: String) {
//        let history = HistoryEntry(medicineId: medicineId, user: user, action: action, details: details)
//        do {
//            try db.collection("history").document(history.id ?? UUID().uuidString).setData(from: history)
//        } catch let error {
//            print("Error adding history: \(error)")
//        }
//    }
    //created new Service
    func fetchHistory(for medicine: Medicine) {
        self.medicineRepository.fetchHistory(for: medicine)
    }
}
