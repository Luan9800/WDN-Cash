import SwiftUI

class ChartViewModel: ObservableObject {
    @Published var dataPoints: [ChartDataPoint] = []

    func fetchChartData() {
        let urlString = "https://economia.awesomeapi.com.br/json/daily/USD-BRL/10"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Erro na Requisição: \(error)")
                return
            }
            guard let data = data else {
                print("Dados Inválidos")
                return
            }

            do {
                let response = try JSONDecoder().decode([HistoricalDollarResponse].self, from: data)
                DispatchQueue.main.async {
                    self.dataPoints = response
                        .map {
                            ChartDataPoint(
                                date: Date(timeIntervalSince1970: TimeInterval($0.timestamp) ?? 0),
                                value: Double($0.bid) ?? 0
                            )
                        }
                        .sorted { $0.date < $1.date }
                }
            } catch {
                print("Erro ao decodificar histórico: \(error)")
            }
        }.resume()
    }

    func update(with quotes: [Quote]) {
        dataPoints = quotes.map { quote in
            ChartDataPoint(date: quote.timestamp, value: quote.value)
        }
    }
}

