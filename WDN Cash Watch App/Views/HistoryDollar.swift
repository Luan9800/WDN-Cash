import SwiftUI
import Foundation

struct HistoryDollar: View {
    @State private var quotes: [String: Double] = [:]
    @Environment(\.dismiss) private var dismiss
    private let storage = HistoryDollarModel()
    
    var body: some View {
        VStack(spacing: 10) {
          Spacer()
            Text("Cotação da Semana")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.yellow)
                .multilineTextAlignment(.center)
                .padding(.bottom, -5)
            
            ForEach(storage.orderedWeekDays, id: \.self) { day in
                HStack {
                    Text(day)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    if let value = quotes[day] {
                        Text(String(format: "R$ %.2f", value))
                            .foregroundColor(value < 0 ? .red : .green)
                    } else {
                        Text("_")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
                .background(Color.black)
            Button("Voltar") {
                dismiss()
            }
            .font(.system(size: 14))
            .foregroundColor(.yellow)
            .buttonStyle(.plain)
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            loadQuotes()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func loadQuotes() {
        quotes = storage.loadAllQuotes()
    }
}

struct HistoryDollar_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDollar()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
