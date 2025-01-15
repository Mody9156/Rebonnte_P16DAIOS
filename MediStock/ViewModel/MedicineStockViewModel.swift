import Foundation
import Firebase

class MedicineStockViewModel: ObservableObject {
    @Published var medicines: [Medicine]
    @Published var aisles: [String] = []
    @Published var history: [HistoryEntry] = []
    @Published var medicineRepository = MedicineRepository()
    
    init(medicines: [Medicine] = MedicineRepository().medicines) {
        self.medicines = medicines
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
    
    func changeStock(_ medicine: Medicine, user: String, stocks:Int) {
        DispatchQueue.global(qos:.background).async{
            self.updateStock(medicine, by: stocks, user: user)
            print("super utilisation de changeStock")
        }
    }
    
    private func updateStock(_ medicine: Medicine, by amount: Int, user: String) {
        DispatchQueue.global(qos:.background).async{
            self.medicineRepository.updateStock(medicine, by: amount, user: user)
        }
    }
    func updateMedicine(_ medicine: Medicine, user: String) {
        DispatchQueue.global(qos:.background).async{
            self.medicineRepository.updateMedicine(medicine, user: user)
            print("super utilisation de updateMedicine")
        }
    }

    func fetchHistory(for medicine: Medicine) {
        DispatchQueue.global(qos:.background).async{
            self.medicineRepository.fetchHistory(for: medicine){ history in
                self.history = [history]
                print("history : \(self.history)")
            }
        }
    }
}
