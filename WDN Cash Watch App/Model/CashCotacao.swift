import Foundation

struct Quote: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Date
    let value: Double
}
