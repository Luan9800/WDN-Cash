import SwiftUI
import UserNotifications

class CashViewModel: ObservableObject {
    @Published var dollarRate: String = "--"
    @Published var variation: String?
    @Published var percentageVariation: String?
    @Published var isFalling: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var quotes: [Quote] = []
    
    private var previousBid: Double?
    let limiteVariacao: Double = 0.20
    
    private let weeklyQuoteKey = "weeklyDollarQuote"
    
    func fetchDollarRate(completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://economia.awesomeapi.com.br/json/last/USD-BRL") else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            completion?()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = "Erro: \(error.localizedDescription)"
                    completion?()
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "Dados não encontrados"
                    completion?()
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode([String: DollarResponse].self, from: data)
                    if let usd = result["USDBRL"], let newBid = Double(usd.bid) {
                        let formattedRate = "R$ \(String(format: "%.2f", newBid))"
                        
                        // Sempre atualiza a taxa formatada
                        self.dollarRate = formattedRate
                        
                        // Só atualiza variações e histórico se o valor mudou
                        let lastQuote = self.quotes.last?.value
                        if lastQuote == nil || abs(newBid - lastQuote!) > 0.001 {
                            self.updateVariation(from: newBid)
                            
                            let newQuote = Quote(timestamp: Date(), value: newBid)
                            self.quotes.append(newQuote)
                            if self.quotes.count > 10 {
                                self.quotes.removeFirst()
                            }
                            
                            self.saveWeeklyQuote(value: newBid)
                        }
                    } else {
                        self.errorMessage = "Resposta inválida"
                    }
                } catch {
                    self.errorMessage = "Erro ao decodificar: \(error.localizedDescription)"
                }
                
                completion?()
            }
        }.resume()
    }
    
    
    private func updateVariation(from newBid: Double) {
        guard let previous = quotes.dropLast().last?.value else {
            variation = nil
            percentageVariation = nil
            isFalling = false
            return
        }
        
        let diff = newBid - previous
        isFalling = diff < 0
        
        variation = String(format: "%.2f", abs(diff))
        
        let percentage = (diff / previous) * 100
        percentageVariation = String(format: "%.2f%%", abs(percentage))
        
        // Envia notificação se a variação for acima do limite
        if abs(diff) >= limiteVariacao {
            enviarNotificacao(variacao: diff)
        }
    }
    
    func pedirPermissaoNotificacao() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Erro ao pedir permissão: \(error.localizedDescription)")
            }
        }
    }
    
    func enviarNotificacao(variacao: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Variação do Dólar 📊"
        content.body = variacao > 0 ?
        "O dólar subiu R$ \(String(format: "%.2f", variacao)) 📈" :
        "O dólar caiu R$ \(String(format: "%.2f", abs(variacao))) 📉"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            }
        }
    }
    
    func saveWeeklyQuote(value: Double) {
        let today = Date()
        let currentWeek = Calendar.current.component(.weekOfYear, from: today)
        let currentYear = Calendar.current.component(.yearForWeekOfYear, from: today)
        
        let key = "\(weeklyQuoteKey)_\(currentYear)_\(currentWeek)"
        UserDefaults.standard.set(value, forKey: key)
        
        print("Cotação da semana salva: \(value) [\(key)]")
    }
    
    func getSavedWeeklyQuote() -> Double? {
        let today = Date()
        let currentWeek = Calendar.current.component(.weekOfYear, from: today)
        let currentYear = Calendar.current.component(.yearForWeekOfYear, from: today)
        
        let key = "\(weeklyQuoteKey)_\(currentYear)_\(currentWeek)"
        return UserDefaults.standard.double(forKey: key)
    }
}

