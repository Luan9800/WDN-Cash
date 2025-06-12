import SwiftUI
import CoreLocation

struct CurrencyConverterWatchView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var justUpdated: Bool = false
    @State private var selectedCurrency: String = "BRL"
    @State private var amountText: String = ""

    var convertedValue: Double {
        guard let amount = Double(amountText),
              let rate = viewModel.currencyRates[selectedCurrency] else {
            return 0.0
        }
        return amount * rate
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                Text("Conversor")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.blue)

                // Campo de entrada
                TextField("USD", text: $amountText)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.green)
                    .labelsHidden()

                // Picker de moeda
                if !viewModel.currencyRates.isEmpty {
                    Picker("", selection: $selectedCurrency) {
                        ForEach(viewModel.currencyRates.keys.sorted(), id: \.self) { currency in
                            Text(currency)
                                .font(.system(size: 12))
                                .tag(currency)
                        }
                    }
                    .labelsHidden()
                    .frame(height: 50)
                }

                // Valor convertido
                if !amountText.isEmpty {
                    Text("≈ \(String(format: "%.2f", convertedValue)) \(selectedCurrency)")
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                }

                // Mensagem de erro de localização
                if let locationError = locationManager.locationError {
                    Text(locationError)
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }

                Spacer()

                // Botão de atualização
                Button(action: {
                    if justUpdated {
                        // Ação de limpar
                        amountText = ""
                        selectedCurrency = locationManager.currencyCode ?? "BRL"
                        justUpdated = false
                    } else {
                        // Ação de cotar
                        viewModel.fetchCurrencyRates()
                        amountText = ""
                        selectedCurrency = locationManager.currencyCode ?? "BRL"
                        justUpdated = true
                    }
                }) {
                    HStack(spacing: 8) {
                      Text( "Limpar")
                        }
                    .font(.system(size: 14, weight: .medium))
                    .padding(.vertical, 7)
                    .frame(maxWidth: 110)
                    .background(Color.blue)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }

                // Mensagem de erro da API
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 20)
            .padding(.top, -20)
            .buttonStyle(.plain)
        }
        .onAppear {
            viewModel.fetchCurrencyRates()
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.currencyCode) { newCurrency, _ in
            // Safely unwrap newCurrency with default
            let currency = newCurrency ?? "BRL"
            if viewModel.currencyRates.keys.contains(currency) {
                selectedCurrency = currency
            } else {
                selectedCurrency = "BRL" // Fallback
            }
        }
    }
}

struct CurrencyConverterWatchView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyConverterWatchView()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
