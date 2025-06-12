import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Notificações sobre o Dólar")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Receba alertas quando o dólar subir ou cair mais que R$ 0,20.")
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if permissionStatus == .authorized {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.green)
                
                Text("Notificações ativadas")
                    .foregroundColor(.green)
            } else if permissionStatus == .denied {
                Image(systemName: "bell.slash.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.red)
                
                Text("Notificações desativadas")
                    .foregroundColor(.red)
                
                Button("Abrir Ajustes") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                .foregroundColor(.blue)
            } else {
                Button("Ativar Notificações") {
                    requestPermission()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.black)
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

struct _Previews: PreviewProvider {
    static var previews: some View {
        HistoryDollar()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}

