import SwiftUI
import UserNotifications

struct NotificationView: View {
    @State private var permissionStatus: UNAuthorizationStatus = .notDetermined
    @StateObject private var manager = NotificationManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Notificações do Dólar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text("Receba Alertas Quando o dólar subir ou cair mais que R$ 0,20.")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                switch manager.permissionStatus {
                case .authorized:
                    VStack(spacing: 12) {
                        Image(systemName: "bell.badge.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.green)
                        
                        Text("Notificações Ativadas")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.green)
                        
                        // Botão para agendar notificação de teste
                        Button(action: {
                            manager.scheduleTestNotification()
                        }) {
                            Text("Ativar Notificações")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 8)
                        
                        // Botão para desativar
                        Button(action: {
                            manager.disableNotifications()
                        }) {
                            Text("Desativar Notificações")
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 5)
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    
                case .provisional:
                    VStack(spacing: 6) {
                        HStack {
                          Text("Notificações Provisórias")
                                .font(.system(size: 13))
                                .foregroundColor(.yellow)
                            
                          Image(systemName: "bell.badge")
                                .font(.system(size: 20))
                                .foregroundColor(.yellow)
                        }
                        Text("O Sistema pode Enviar Alertas Silenciosos.")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    
                case .denied:
                    VStack(spacing: 6) {
                        Image(systemName: "bell.slash.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                        
                        Text("Notificações Desativadas")
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                        
                        Text("Abra o app Watch no iPhone e ative as notificações para este app.")
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                    
                case .notDetermined:
                    Button("Ativar Notificações") {
                        manager.requestPermission()
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .buttonStyle(.plain)
                    
                @unknown default:
                    Text("Status Desconhecido.")
                        .foregroundColor(.orange)
                }
            }
            .padding()
        }
        .background(Color.black)
        .onAppear {
            manager.checkNotificationStatus()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .previewDevice("Apple Watch Series 9 - 45mm")
    }
}
