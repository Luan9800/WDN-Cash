import Foundation
import Combine


struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct HistoricalDollarResponse: Decodable {
    let bid: String
    let timestamp: String

    enum CodingKeys: String, CodingKey {
        case bid = "bid"
        case timestamp = "timestamp"
    }
}
