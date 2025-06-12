import SwiftUI


struct CurrencyView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Cotações de Moedas 🌍")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .green))
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(viewModel.currencyRates.keys.sorted(), id: \.self) { currency in
                    Text("\(currency): R$ \(String(format: "%.2f", viewModel.currencyRates[currency]!))")
                        .font(.system(size: 18))
                        .padding(.vertical, 4)
                }
            }
            
            Button(action: viewModel.fetchCurrencyRates) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    Text("Atualizar Cotações")
                }
                .font(.system(size: 15))
                .frame(maxWidth: 150)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.85))
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .onAppear(perform: viewModel.fetchCurrencyRates)
    }
    
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
          CurrencyView()
        }
    }
}
