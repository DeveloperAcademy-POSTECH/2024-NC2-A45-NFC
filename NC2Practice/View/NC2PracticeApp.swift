//
//  NC2PracticeApp.swift
//  NC2Practice
//
//  Created by 신혜연 on 6/16/24.
//

import SwiftUI
import UserNotifications

@main
struct NC2PracticeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let showFinishingView = userInfo["showFinishingView"] as? Bool, showFinishingView {
            // NotificationCenter를 통해 MainView에 알림을 전달하여 FinishingView 표시
            NotificationCenter.default.post(name: NSNotification.Name("ShowFinishingView"), object: nil)
        }
        
        completionHandler()
    }
}
