import Foundation

struct CurrencyResponse: Decodable {
    let base: String
    let date: String
    let rates: [String: Double]
}

 struct CurrencyEntry: Identifiable {
    let id = UUID()
    let date: String 
    let value: Double
}
