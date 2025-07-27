import Foundation
import UserNotifications

final class NotificationManager: ObservableObject {
    @Published var permissionStatus: UNAuthorizationStatus = .notDetermined
    static let shared = NotificationManager()
    private let ultimaCotacoaKey = "ultimaCotacao"
    
    private init() {
        checkNotificationStatus()
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.checkNotificationStatus()
            }
        }
    }
    
    func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.permissionStatus = settings.authorizationStatus
            }
        }
    }
    

    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Dólar em Queda 📉"
        content.body = "O dólar caiu mais de R$ 0,20! Hora de Comprar?"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error)")
            } else {
                print("Notificação agendada com sucesso!")
            }
        }
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        DispatchQueue.main.async {
            self.permissionStatus = .denied
        }
    }
}
