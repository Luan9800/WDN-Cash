import SwiftUI
import UserNotifications

struct NotificationView: View {
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined

    var body: some View {
        VStack(spacing: 20) {
            Text("Notificações do Dólar")
                .font(.headline)
                .foregroundColor(.white)

            Text("Receba alertas quando o dólar subir ou cair mais que R$ 0,20.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            switch permissionStatus {
            case .authorized:
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.green)
                Text("Notificações ativadas")
                    .foregroundColor(.green)

            case .denied:
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.red)
                Text("Notificações desativadas")
                    .foregroundColor(.red)
                Text("Abra o app Watch no iPhone e ative as notificações para este app.")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)

            case .notDetermined:
                Button("Ativar Notificações") {
                    requestPermission()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.black)
                .cornerRadius(10)

            default:
                EmptyView()
            }
        }
        .padding()
        .background(Color.black)
        .buttonStyle(.plain)
        .onAppear {
            checkNotificationStatus()
        }
    }

    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                checkNotificationStatus()
            }
        }
    }

    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.permissionStatus = settings.authorizationStatus
            }
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
