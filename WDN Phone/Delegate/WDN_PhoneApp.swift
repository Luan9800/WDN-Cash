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
    var body: some Scene {
        
        let test = NotificationDelegate()
        
        @UIApplicationDelegateAdaptor(NotificationDelegate.self)
            var appDelegate
        
        WindowGroup {
            ContentView()
        }
    }
}
