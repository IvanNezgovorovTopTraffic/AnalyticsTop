import Foundation
import UIKit

// MARK: -- HeraldMaster

/// Главный глашатай для объявления королевских указов и оповещений
public final class HeraldMaster {
    
    // MARK: -- Public Properties
    
    public static let sovereign = HeraldMaster()
    
    // MARK: -- Init
    
    private init() {}
    
    // MARK: -- Public Functions
    
    /// Объявляет указ о необходимости включения уведомлений с переходом в палаты настроек
    public func proclaimNotificationDecree() {
        let royalProclamation = UIAlertController(
            title: "Notification are disabled",
            message: "To receive notifications, please enable them in sttings.",
            preferredStyle: .alert
        )
        
        guard
            let throneRoom = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let chamberlain = throneRoom.windows
                .first(where: { $0.isKeyWindow })?.rootViewController
        else {
            return
        }
        
        royalProclamation.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsChamber = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(settingsChamber) {
                UIApplication.shared.open(settingsChamber)
            }
        })
        
        royalProclamation.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        chamberlain.present(royalProclamation, animated: true)
    }
    
    /// Объявляет королевский указ с настраиваемыми параметрами
    /// - Parameters:
    ///   - title: Заголовок королевского указа
    ///   - message: Текст королевского послания
    ///   - primaryButtonTitle: Текст главной печати
    ///   - secondaryButtonTitle: Текст вспомогательной печати (опционально)
    ///   - primaryAction: Действие при главной печати
    ///   - secondaryAction: Действие при вспомогательной печати (опционально)
    public func proclaimCustomDecree(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        let royalEdict = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        guard
            let throneRoom = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let chamberlain = throneRoom.windows.first?.rootViewController
        else {
            
            return
        }
        
        // Главная королевская печать
        royalEdict.addAction(UIAlertAction(title: primaryButtonTitle, style: .default) { _ in
            primaryAction?()
            
        })
        
        // Вспомогательная печать (если предусмотрена)
        if let secondarySeal = secondaryButtonTitle {
            royalEdict.addAction(UIAlertAction(title: secondarySeal, style: .cancel) { _ in
                secondaryAction?()
                
            })
        }
        
        chamberlain.present(royalEdict, animated: true)
        
    }
    
    /// Объявляет указ с королевским подтверждением
    /// - Parameters:
    ///   - title: Заголовок королевского указа
    ///   - message: Текст королевского послания
    ///   - confirmTitle: Текст печати подтверждения (по умолчанию "OK")
    ///   - cancelTitle: Текст печати отмены (по умолчанию "Cancel")
    ///   - onConfirm: Действие при королевском согласии
    ///   - onCancel: Действие при королевском отказе (опционально)
    public func proclaimConfirmationDecree(
        title: String,
        message: String,
        confirmTitle: String = "OK",
        cancelTitle: String = "Cancel",
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        proclaimCustomDecree(
            title: title,
            message: message,
            primaryButtonTitle: confirmTitle,
            secondaryButtonTitle: cancelTitle,
            primaryAction: onConfirm,
            secondaryAction: onCancel
        )
    }
}
