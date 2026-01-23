import Foundation
import UserNotifications

final class NotificationManager: ObservableObject {
    @Published var permissionStatus: UNAuthorizationStatus = .notDetermined
    static let shared = NotificationManager()
    private let ultimaCotacoaKey = "ultimaCotacao"
    
    private init() {
        checkNotificationStatus()
    }
    
    // MARK: - Permissões
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
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
    
    // MARK: - Notificações
    
    /// Apenas um teste rápido (não mexe no histórico)
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Dólar em Queda 📉"
        content.body = "O Dólar caiu mais de R$ 0,20! Hora de Comprar?"
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
                print("✅ Notificação de TESTE agendada com sucesso!")
            }
        }
    }
    
    /// Notificação real com a cotação + salva no histórico
    func scheduleDollarNotification(cotacao: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Cotação do Dólar 💵"
        content.body = "Hoje está em R$ \(String(format: "%.2f", cotacao))"
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
                print("✅ Notificação com cotação agendada e salva no histórico!")
                
                // 🔑 Salva no histórico
                let history = HistoryDollarModel()
                history.saveQuote(value: cotacao)
                
                // Salva a última cotação para consultas rápidas
                UserDefaults.standard.set(cotacao, forKey: self.ultimaCotacoaKey)
            }
        }
    }
    
    // Última cotação salva (sem precisar abrir histórico)
    func getLastCotacao() -> Double? {
        return UserDefaults.standard.double(forKey: ultimaCotacoaKey)
    }
    
    func disableNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        DispatchQueue.main.async {
            self.permissionStatus = .denied
        }
    }
}
