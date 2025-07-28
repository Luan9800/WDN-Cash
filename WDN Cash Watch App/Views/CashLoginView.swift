import SwiftUI
import UserNotifications

struct CashLoginView: View {
    @State private var isActive = false
    @State private var rotateIcon = false
    @State private var animateColor = false
    @StateObject private var viewModel = CashViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            Spacer()
            if isActive {
                HomeCashView()
                    .transition(.opacity)
            } else {
                VStack(spacing: 10) {
                  Spacer()
                    Image(systemName: "dollarsign.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .foregroundColor(animateColor ? locationManager.countryColors.first ?? .green : locationManager.countryColors.last ?? .green)
                        .rotationEffect(.degrees(rotateIcon ? 360 : 0))
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: rotateIcon)
                    
                    // Mensagem de boas-vindas com cor baseada no tema do país
                    if let country = locationManager.countryName,
                       let currency = locationManager.currencyCode,
                       currency != "BRL" {
                        Text("🌍 Bem-vindo ao \(country)!\nVamos converter a moeda para \(currency)?")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(locationManager.countryColors.first ?? .green)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    VStack(spacing: 4) {
                     Spacer()
                        Text("Bem Vindo ao")
                            .font(.footnote)
                            .foregroundColor(locationManager.countryColors.count > 1 ? locationManager.countryColors[1] : .gray)

                        Text("WDN Cash")
                            .font(.title2.bold())
                            .foregroundColor(locationManager.countryColors.first ?? .green)
                    }

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: locationManager.countryColors.last ?? .white))
                        .scaleEffect(0.9)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .onAppear {
                    rotateIcon = true
                    animateColor.toggle()
                    viewModel.pedirPermissaoNotificacao()
                    locationManager.requestLocation()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        withAnimation(.easeOut) {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

struct CashLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CashLoginView()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
