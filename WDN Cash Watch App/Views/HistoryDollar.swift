import SwiftUI

struct HistoryDollar: View {
    @State private var lastQuote: Double?
    @State private var weekDay: String = ""
    
    private let storage = HistoryDollarModel()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Cotação da Semana")
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 2)
            
            if let quote = lastQuote {
                Text(String(format: "R$ %.2f", quote))
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.green)
                    .minimumScaleFactor(0.5)
                
                Text("Atualizado na \(weekDay)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            } else {
                VStack(spacing: 4) {
                    Text("Sem dados disponíveis")
                        .font(.callout)
                        .foregroundColor(.red)
                    
                    Text("Toque em \"Atualizar\" no app principal.")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            loadQuote()
        }
    }
    
    private func loadQuote() {
        if let savedQuote = storage.loadWeeklyQuote() {
            lastQuote = savedQuote.value
            weekDay = savedQuote.weekDay
        }
    }
}

struct HistoryDollar_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDollar()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
