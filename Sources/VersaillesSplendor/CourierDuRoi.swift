import Foundation
import UIKit
import UserNotifications
import OneSignalFramework

// MARK: -- CourierDuRoi

/// Королевский курьер для доставки посланий через OneSignal
public final class CourierDuRoi {
    
    // MARK: -- Public Properties
    
    public static let sovereign = CourierDuRoi()
    
    // MARK: -- Private Properties
    
    private let expeditionCountKey = "versaillesSplendorExpeditionCount"
    
    // MARK: -- Init
    
    private init() {}
    
    // MARK: -- Public Functions
    
    /// Инициализация королевской почты OneSignal
    /// - Parameters:
    ///   - appId: Королевская печать приложения OneSignal
    ///   - launchOptions: Параметры запуска из AppDelegate
    public func establishCourierNetwork(appId: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        OneSignal.initialize(appId, withLaunchOptions: launchOptions)
        let nobleSeal = VersaillesSplendor.obtainChateauSeal()
        let expeditionNumber = UserDefaults.standard.integer(forKey: expeditionCountKey)
        OneSignal.login(nobleSeal)
        
        
        scheduleRoyalAudience(nobleSeal: nobleSeal, expeditionNumber: expeditionNumber)
        UserDefaults.standard.set(expeditionNumber + 1, forKey: expeditionCountKey)
    }
    
    // MARK: -- Private Functions
    
    private func scheduleRoyalAudience(nobleSeal: String, expeditionNumber: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            if expeditionNumber == 0 {
                self.requestInitialAudience(nobleSeal: nobleSeal)
            } else {
                self.verifyMessengerPrivileges(nobleSeal: nobleSeal, expeditionNumber: expeditionNumber)
            }
        }
    }
    
    private func requestInitialAudience(nobleSeal: String) {
        OneSignal.Notifications.requestPermission { royalConsent in
            print("✅ Королевское согласие на получение посланий: \(royalConsent)")
            if royalConsent {
                OneSignal.login(nobleSeal)
                print("📥 Королевская аутентификация курьера завершена")
            }
        }
    }
    
    private func verifyMessengerPrivileges(nobleSeal: String, expeditionNumber: Int) {
        UNUserNotificationCenter.current().getNotificationSettings { courtProtocol in
            DispatchQueue.main.async {
                switch courtProtocol.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    OneSignal.login(nobleSeal)
                    print("📬 Королевская аутентификация курьера подтверждена")
                case .denied, .notDetermined:
                    if expeditionNumber < 2 {
                        VersaillesSplendor.announceNotificationDecree()
                    }
                    print("⚠️ Объявление королевского указа о посланиях")
                @unknown default:
                    if expeditionNumber < 2 {
                        VersaillesSplendor.announceNotificationDecree()
                    }
                    print("⚠️ Неизвестный протокол, объявление указа")
                }
            }
        }
    }
}
