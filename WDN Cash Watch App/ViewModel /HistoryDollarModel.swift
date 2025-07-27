import Foundation

struct HistoryDollarModel {
    private let quotesKey = "weeklyDollarQuotes"
    private let weekKey = "currentWeekNumber"
    
    /// Salva a cotação do dia. Limpa se for nova semana.
    func saveQuote(for date: Date = Date(), value: Double) {
        clearIfNewWeek(currentDate: date)
        
        let weekDay = getWeekDay(from: date)
        var quotes = loadAllQuotes()
        quotes[weekDay] = value
        UserDefaults.standard.set(quotes, forKey: quotesKey)
    }
    
    /// Retorna todas as cotações da semana atual.
    func loadAllQuotes() -> [String: Double] {
        clearIfNewWeek(currentDate: Date())
        return UserDefaults.standard.dictionary(forKey: quotesKey) as? [String: Double] ?? [:]
    }
    
    /// Apaga todas as cotações salvas.
    func clearAllQuotes() {
        UserDefaults.standard.removeObject(forKey: quotesKey)
        UserDefaults.standard.removeObject(forKey: weekKey)
    }
    
    /// Dias úteis ordenados para exibição.
    var orderedWeekDays: [String] {
        ["Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira"]
    }
    
    private func getWeekDay(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).capitalized
    }
    
    private func getCurrentWeekNumber(for date: Date) -> Int {
        let calendar = Calendar(identifier: .iso8601)
        return calendar.component(.weekOfYear, from: date)
    }
    
    private func clearIfNewWeek(currentDate: Date) {
        let currentWeek = getCurrentWeekNumber(for: currentDate)
        
        if let savedWeek = UserDefaults.standard.object(forKey: weekKey) as? Int {
            if savedWeek != currentWeek {
                clearAllQuotes()
                UserDefaults.standard.set(currentWeek, forKey: weekKey)
            }
        } else {
            // Primeira vez salvando
            UserDefaults.standard.set(currentWeek, forKey: weekKey)
        }
    }
}
