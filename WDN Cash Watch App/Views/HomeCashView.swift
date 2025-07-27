import SwiftUI

struct HomeCashView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 3) {
                Text("Home")
                    .font(.system(size: 16, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                
                NavigationLink(destination: CashView()) {
                    Label("Cotação do Dia", systemImage: "banknote")
                        .modifier(MenuButtonStyle(background: .green, foreground: .black))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: CurrencyConverterWatchView()) {
                    Label("Conversor de Moedas", systemImage: "arrow.left.arrow.right")
                        .modifier(MenuButtonStyle(background: .blue, foreground: .black))
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: HistoryDollar()) {
                    Label("Histórico Semanal", systemImage: "calendar")
                        .modifier(MenuButtonStyle(background: .orange, foreground: .black))
                        .cornerRadius(10)
                }
                NavigationLink (destination: NotificationView()) {
                    Label("Notificação Dólar", systemImage: "exclamationmark.bubble")
                        .modifier(MenuButtonStyle(background: .yellow, foreground: .black))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, -8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .cornerRadius(10)
            .buttonStyle(.plain)
        }
    }
}

struct MenuButtonStyle: ViewModifier {
    var background: Color
    var foreground: Color
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .medium))
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(background)
            .foregroundColor(foreground)
            .cornerRadius(12)
    }
}

struct HomeCashView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCashView()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
