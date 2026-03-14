//
//  WDN_PhoneApp.swift
//  WDN Phone
//
//  Created by Luan Carlos on 18/01/26.
//

import SwiftUI
import Combine
import UserNotifications

@main
struct WDN_PhoneApp: App {
    
    @UIApplicationDelegateAdaptor(NotificationDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
