import Foundation

struct HistoryDollarModel {
    private let key = "weeklyDollarQuote"
    
    func saveWeeklyQuote(value: Double, date: Date = Date()) {
        let weekDay = getWeekDay(from: date)
        let dict: [String: Any] = ["value": value, "weekDay": weekDay]
        UserDefaults.standard.set(dict, forKey: key)
    }
    
    func loadWeeklyQuote() -> (value: Double, weekDay: String)? {
        guard let dict = UserDefaults.standard.dictionary(forKey: key),
              let value = dict["value"] as? Double,
              let weekDay = dict["weekDay"] as? String else {
            return nil
        }
        return (value, weekDay)
    }
    
    private func getWeekDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).capitalized
    }
    
    // Função para limpar o dado — use para resetar na segunda-feira
    func clearStoredQuote() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
