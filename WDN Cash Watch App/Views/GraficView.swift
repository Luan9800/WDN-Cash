import SwiftUI

struct GraficView: View {
    @ObservedObject var cashViewModel: CashViewModel
    @ObservedObject var chartViewModel: ChartViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showInfo = false

    var body: some View {
        VStack(spacing: 8) {
            Text("Histórico do Dólar")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            if chartViewModel.dataPoints.isEmpty {
                Text("Nenhum dado disponível")
                    .font(.caption2)
                    .foregroundColor(.gray)
            } else {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height

                    let values = chartViewModel.dataPoints.map { $0.value }
                    let maxValue = values.max() ?? 1.0
                    let minValue = values.min() ?? 0.0
                    let range = maxValue - minValue == 0 ? 1 : maxValue - minValue

                    let isFalling = values.last ?? 0 < values.first ?? 0
                    let lineColor = isFalling ? Color.red : Color.green

                    let points = values.enumerated().map { index, value in
                        CGPoint(
                            x: CGFloat(index) / CGFloat(values.count - 1) * width,
                            y: height - ((value - minValue) / range) * height
                        )
                    }

                    ZStack {
                        ForEach(0..<4) { i in
                            let y = CGFloat(i) / 3 * height
                            Path { path in
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                            .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                        }

                        Path { path in
                            guard points.count > 1 else { return }
                            path.move(to: points[0])
                            for i in 1..<points.count {
                                let mid = CGPoint(
                                    x: (points[i].x + points[i - 1].x) / 2,
                                    y: (points[i].y + points[i - 1].y) / 2
                                )
                                path.addQuadCurve(to: mid, control: points[i - 1])
                            }
                            path.addLine(to: CGPoint(x: points.last!.x, y: height))
                            path.addLine(to: CGPoint(x: points.first!.x, y: height))
                            path.closeSubpath()
                        }
                        .fill(lineColor.opacity(0.2))

                        Path { path in
                            guard points.count > 1 else { return }
                            path.move(to: points[0])
                            for i in 1..<points.count {
                                let mid = CGPoint(
                                    x: (points[i].x + points[i - 1].x) / 2,
                                    y: (points[i].y + points[i - 1].y) / 2
                                )
                                path.addQuadCurve(to: mid, control: points[i - 1])
                            }
                            path.addLine(to: points.last!)
                        }
                        .stroke(lineColor, lineWidth: 2)
                        .shadow(color: lineColor.opacity(0.4), radius: 2, x: 0, y: 2)

                        // Mostrar info ao tocar
                        if showInfo {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Alta: R$ \(String(format: "%.2f", maxValue))")
                                Text("Baixa: R$ \(String(format: "%.2f", minValue))")
                            }
                            .font(.caption2)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(6)
                            .position(x: width * 0.3, y: 20)
                            .transition(.opacity)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation {
                            showInfo.toggle()
                        }
                    }
                }
                .frame(height: 100)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 4)
            }

            Button("Voltar") {
                dismiss()
            }
            .font(.system(size: 13))
            .foregroundColor(.blue)
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(Color.black)
        .onAppear {
            chartViewModel.fetchChartData()
        }
    }
  }

struct ChartView_Preview: PreviewProvider {
    static var previews: some View {
        let cashVM = CashViewModel()
        let chartVM = ChartViewModel()

        GraficView(cashViewModel: cashVM, chartViewModel: chartVM)
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
