import Foundation

class HeartsDataManager {
    static let shared = HeartsDataManager()
    
    private let heartsDataKey = "HeartsDataKey"
    
    func saveHeartsData(_ data: HeartsData) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            UserDefaults.standard.set(encodedData, forKey: heartsDataKey)
        }
    }
    
    func loadHeartsData() -> HeartsData? {
        if let encodedData = UserDefaults.standard.data(forKey: heartsDataKey) {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(HeartsData.self, from: encodedData) {
                return decodedData
            }
        }
        return nil
    }
}
