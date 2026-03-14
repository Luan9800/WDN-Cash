import Foundation

struct Quote: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Date
    let value: Double
}

struct PTAXResponse: Codable {
    let value: [PTAXQuote]
}

struct PTAXQuote: Codable {
    let cotacaoCompra: Double
    let cotacaoVenda: Double
    let dataHoraCotacao: String
}


