import SwiftUI

class CurrencyViewModel: ObservableObject {
    @Published var currencyRates: [String: Double] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchCurrencyRates() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/USD") else {
            self.errorMessage = "URL inválida"
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
                    self.errorMessage = "Dados Inválidos!"
                    return
                }

                do {
                    let result = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                    self.currencyRates = result.rates
                } catch {
                    self.errorMessage = "Erro ao decodificar dados"
                }
            }
        }.resume()
    }
}
