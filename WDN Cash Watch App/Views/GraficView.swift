import SwiftUI

struct ChartView: View {
    @ObservedObject var viewModel: CashViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 8) {
            Text("Histórico do Dólar")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .accessibilityLabel("Gráfico do histórico da cotação do dólar")

            if viewModel.quotes.isEmpty {
                Text("Nenhum dado disponível")
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let values = viewModel.quotes.map { $0.value }
                    let maxValue = values.max() ?? 1.0
                    let minValue = values.min() ?? 0.0
                    let valueRange = maxValue - minValue == 0 ? 1.0 : maxValue - minValue

                    Path { path in
                        for (index, quote) in viewModel.quotes.enumerated() {
                            let x = CGFloat(index) / CGFloat(viewModel.quotes.count - 1) * width
                            let y = height - ((quote.value - minValue) / valueRange) * height
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(viewModel.isFalling ? Color.red : Color.green, lineWidth: 2)
                    .accessibilityLabel("Gráfico de linha mostrando \(viewModel.isFalling ? "queda" : "alta") na cotação")
                }
                .frame(height: 80)
                .padding(.horizontal, 4)
            }

            Button(action: { dismiss() }) {
                Text("Voltar")
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .accessibilityHint("Volta para a tela anterior")
        }
        .padding(.vertical, 8)
    }
}

struct ChartView_Preview: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: CashViewModel())
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
