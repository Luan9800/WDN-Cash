import SwiftUI


class CashModel: ObservableObject {
    @Published var dollarRate : String = "--"
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchDollarRate() {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://economia.awesomeapi.com.br/json/last/USD-BRL"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "URL Inválida"
            self.isLoading = false
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
                   DispatchQueue.main.async {
                       self.isLoading = false

                       if let error = error {
                           self.errorMessage = error.localizedDescription
                           return
                       }

                       guard let data = data else {
                           self.errorMessage = "Dados inválidos"
                           return
                       }

                       do {
                           let result = try JSONDecoder().decode([String: DollarResponse].self, from: data)
                           if let usd = result["USDBRL"] {
                               self.dollarRate = "R$ " + String(format: "%.2f", Double(usd.bid) ?? 0.0)
                           }
                       } catch {
                           self.errorMessage = "Erro ao decodificar dados"
                       }
                   }
               }.resume()
           }
       }
