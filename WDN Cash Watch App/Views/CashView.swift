import SwiftUI

struct CashView: View {
    
    @State private var showTrend = false
    @State private var previousRate: String?
    @State private var resetWorkItem: DispatchWorkItem?
    @StateObject private var viewModel = CashViewModel()
    @StateObject private var chartViewModel = ChartViewModel()
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Button(action: {
                    dismiss()
                }) {
                    Text(showTrend && viewModel.variation != nil ? (viewModel.isFalling ? "Dólar Em Queda" : "Dólar Em Alta") : "Dólar : USD")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .accessibilityLabel(showTrend && viewModel.variation != nil ? (viewModel.isFalling ? "Dólar em queda" : "Dólar em alta") : "Cotação do dólar")
                }
                .buttonStyle(.plain)

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    VStack(spacing: 4) {
                        Text(viewModel.dollarRate)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(viewModel.isFalling ? .red : .green)
                            .transition(.opacity)

                        if let variation = viewModel.variation {
                            HStack(spacing: 4) {
                                Image(systemName: viewModel.isFalling ? "arrow.down" : "arrow.up")
                                Text("R$ \(variation)")
                                if let percentage = viewModel.percentageVariation {
                                    Text("(\(percentage))")
                                }
                            }
                            .font(.footnote)
                            .foregroundColor(viewModel.isFalling ? .red : .green)
                            .transition(.opacity)
                        }
                    }
                    .padding(.top, 2)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.dollarRate)
                }

                // Botão Atualizar
                Button(action: {
                    resetWorkItem?.cancel()
                    let oldRate = viewModel.dollarRate

                    viewModel.fetchDollarRate {
                        let newRate = viewModel.dollarRate

                        showTrend = true

                        if newRate != oldRate {
                            previousRate = newRate
                        }

                        let workItem = DispatchWorkItem {
                            showTrend = false
                        }

                        resetWorkItem = workItem
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                        Text("Atualizar")
                    }
                    .font(.system(size: 14))
                    .frame(maxWidth: 125)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(5)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Atualiza a cotação do dólar")


                // Botão Ver Gráfico
                NavigationLink(destination: GraficView(cashViewModel: viewModel, chartViewModel: chartViewModel)) {
                    HStack(spacing: 6) {
                        Image(systemName: "chart.xyaxis.line")
                        Text("Ver Gráfico")
                    }
                    .font(.system(size: 14))
                    .frame(maxWidth: 125)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .foregroundColor(.black)
                    .cornerRadius(5)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Mostra o gráfico do histórico da cotação")
            }
            .padding(.top, 5)
            .onAppear {
                viewModel.fetchDollarRate()
                previousRate = viewModel.dollarRate
                chartViewModel.update(with: viewModel.quotes)
            }
            .onChange(of: viewModel.quotes) { oldValue, newValue in
                chartViewModel.update(with: newValue)
            }
        }
    }
}

struct CashView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            CashView()
            CashView()
                .previewDevice("Apple Watch Series 9 - 45mm")
        }
    }
}
