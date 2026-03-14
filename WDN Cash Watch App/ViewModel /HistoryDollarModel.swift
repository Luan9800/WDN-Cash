import Foundation

enum WeekDay: String, CaseIterable {
    case segunda = "Segunda-feira"
    case terca   = "Terça-feira"
    case quarta  = "Quarta-feira"
    case quinta  = "Quinta-feira"
    case sexta   = "Sexta-feira"
}

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

        guard let raw = UserDefaults.standard.dictionary(forKey: quotesKey) else {
            return [:]
        }

        var result: [String: Double] = [:]

        for (key, value) in raw {
            if let number = value as? NSNumber {
                result[key] = number.doubleValue
            }
        }

        return result
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
        let day = formatter.string(from: date).capitalized
        
        // Mapeia para garantir consistência
        switch day {
        case "Segunda-Feira": return "Segunda-feira"
        case "Terça-Feira": return "Terça-feira"
        case "Quarta-Feira": return "Quarta-feira"
        case "Quinta-Feira": return "Quinta-feira"
        case "Sexta-Feira": return "Sexta-feira"
        default: return day
        }
    }
    
    private func getCurrentWeekNumber(for date: Date) -> Int {
        let calendar = Calendar(identifier: .iso8601)
        return calendar.component(.weekOfYear, from: date)
    }
    
    private func clearIfNewWeek(currentDate: Date) {
        let currentWeek = getCurrentWeekNumber(for: currentDate)
        let savedWeek = UserDefaults.standard.integer(forKey: weekKey)

        if savedWeek == 0 {
            UserDefaults.standard.set(currentWeek, forKey: weekKey)
            return
        }

        if savedWeek != currentWeek {
            clearAllQuotes()
            UserDefaults.standard.set(currentWeek, forKey: weekKey)
        }
    }

}
