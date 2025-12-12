import SwiftUI

// MARK: -- VersaillesSplendor

/// VersaillesSplendor - королевская библиотека для создания величественных анимаций в SwiftUI
public struct VersaillesSplendor {
    
    // MARK: -- Public Functions - Animation Views
    
    /// Создает величественные врата замка с королевским градиентом и анимированным гербом
    /// - Parameters:
    ///   - gradientColors: Массив королевских оттенков для градиента
    ///   - textColor: Цвет приветственной надписи
    ///   - loaderColor: Цвет королевского герба
    ///   - loadingText: Текст королевского приветствия (по умолчанию "Loading...")
    /// - Returns: SwiftUI View с вратами замка
    public static func createCastleGate(
        gradientColors: [Color] = [.blue, .purple, .pink],
        textColor: Color = .white,
        loaderColor: Color = .white,
        loadingText: String = "Loading..."
    ) -> some View {
        CastleGateView(
            royalGradientHues: gradientColors,
            inscriptionTint: textColor,
            heraldryTint: loaderColor,
            welcomeInscription: loadingText
        )
    }
    
    /// Создает анимированную королевскую лилию с пульсирующим геральдическим эффектом
    /// - Parameters:
    ///   - size: Размер королевской лилии
    ///   - color: Цвет геральдики
    ///   - duration: Длительность королевской анимации
    /// - Returns: SwiftUI View с королевской лилией
    public static func createFleurDeLis(size: CGFloat = 50, color: Color = .yellow, duration: Double = 1.0) -> some View {
        FleurDeLisView(royalSize: size, heraldryTint: color, pulseDuration: duration)
    }
    
    /// Создает королевский двор с вращающимися придворными
    /// - Parameters:
    ///   - elementCount: Количество придворных в королевском дворе
    ///   - size: Размер королевской палаты
    ///   - colors: Массив королевских цветов для придворных
    /// - Returns: SwiftUI View с анимированным королевским двором
    public static func createRoyalCourt(elementCount: Int = 8, size: CGFloat = 200, colors: [Color] = [.blue, .purple, .pink]) -> some View {
        RoyalCourtView(courtierCount: elementCount, chamberSize: size, royalPalette: colors)
    }
    
    /// Создает королевский гобелен с движущимися узорами
    /// - Parameters:
    ///   - starCount: Количество нитей в гобелене
    ///   - speed: Скорость плетения узоров
    /// - Returns: SwiftUI View с королевским гобеленом
    public static func createTapestry(starCount: Int = 50, speed: Double = 2.0) -> some View {
        TapestryView(threadCount: starCount, weavingSpeed: speed)
    }
    
    // MARK: -- Public Functions - Web Chronicle
    
    /// Создает королевскую хронику с поддержкой придворных жестов и обновления
    /// - Parameters:
    ///   - urlString: Адрес далеких земель для загрузки
    ///   - allowsGestures: Разрешить придворные жесты навигации (по умолчанию true)
    ///   - enableRefresh: Включить обновление манускрипта (по умолчанию true)
    /// - Returns: SwiftUI View с королевской хроникой
    public static func createChronicle(
        urlString: String,
        allowsGestures: Bool = true,
        enableRefresh: Bool = true
    ) -> some View {
        SafeChronicleView(
            manuscriptAddress: urlString,
            allowsCourtGestures: allowsGestures,
            enableManuscriptRefresh: enableRefresh
        )
    }
    
    // MARK: -- Public Functions - Royal Decree
    
    /// Проверяет доступность далеких земель с королевским кэшированием результатов
    /// - Parameters:
    ///   - url: Адрес для королевской проверки
    ///   - targetDate: Королевская дата (земли доступны только после этой даты)
    ///   - deviceCheck: Проверять ли тип королевского устройства (iPad исключается)
    ///   - timeout: Время ожидания королевских курьеров
    ///   - cacheKey: Уникальная королевская печать для кэширования
    /// - Returns: Королевский вердикт с решением и финальным адресом
    public static func examineDistantRealms(
        url: String,
        targetDate: Date,
        deviceCheck: Bool = true,
        timeout: TimeInterval = 10.0,
        cacheKey: String? = nil
    ) -> RoyalDecree.DecreeVerdict {
        return RoyalDecree.examineDistantRealms(
            url: url,
            targetDate: targetDate,
            deviceCheck: deviceCheck,
            timeout: timeout,
            cacheKey: cacheKey
        )
    }
    
    // MARK: -- Public Functions - Chateau Identity
    
    /// Получает уникальную печать замка
    /// - Returns: Уникальная королевская печать
    public static func obtainChateauSeal() -> String {
        return ChateauKeeper.sovereign.getUniqueChateauSeal()
    }
    
    // MARK: -- Public Functions - Royal Alerts
    
    /// Объявляет королевский указ о необходимости включения уведомлений с переходом в палаты настроек
    public static func announceNotificationDecree() {
        HeraldMaster.sovereign.proclaimNotificationDecree()
    }
    
    /// Объявляет королевский указ с настраиваемыми параметрами
    /// - Parameters:
    ///   - title: Заголовок королевского указа
    ///   - message: Текст королевского послания
    ///   - primaryButtonTitle: Текст главной королевской печати
    ///   - secondaryButtonTitle: Текст вспомогательной печати
    ///   - primaryAction: Действие при главной печати
    ///   - secondaryAction: Действие при вспомогательной печати
    public static func announceCustomDecree(
        title: String,
        message: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        primaryAction: (() -> Void)? = nil,
        secondaryAction: (() -> Void)? = nil
    ) {
        HeraldMaster.sovereign.proclaimCustomDecree(
            title: title,
            message: message,
            primaryButtonTitle: primaryButtonTitle,
            secondaryButtonTitle: secondaryButtonTitle,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        )
    }
    
    /// Объявляет королевский указ с подтверждением действия
    /// - Parameters:
    ///   - title: Заголовок королевского указа
    ///   - message: Текст королевского послания
    ///   - confirmTitle: Текст печати подтверждения
    ///   - cancelTitle: Текст печати отмены
    ///   - onConfirm: Действие при королевском согласии
    ///   - onCancel: Действие при королевском отказе
    public static func announceConfirmationDecree(
        title: String,
        message: String,
        confirmTitle: String = "OK",
        cancelTitle: String = "Cancel",
        onConfirm: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        HeraldMaster.sovereign.proclaimConfirmationDecree(
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            cancelTitle: cancelTitle,
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }
    
    // MARK: -- Public Functions - Royal Courier
    
    /// Инициализирует королевскую почту OneSignal с переданной печатью приложения
    /// - Parameters:
    ///   - appId: Королевская печать приложения OneSignal
    ///   - launchOptions: Параметры запуска из AppDelegate
    public static func establishCourierNetwork(appId: String, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        CourierDuRoi.sovereign.establishCourierNetwork(appId: appId, launchOptions: launchOptions)
    }
}

// MARK: -- ChateauKeeper

/// Хранитель замка - генератор уникальных королевских печатей
public final class ChateauKeeper {
    
    // MARK: -- Public Properties
    
    public static let sovereign = ChateauKeeper()
    
    // MARK: -- Private Properties
    
    private let royalArchivesKey = "versaillesSplendorChateauSeal"
    
    // MARK: -- Init
    
    private init() {}
    
    // MARK: -- Public Functions
    
    /// Получает уникальную печать замка (создает если не существует в королевских архивах)
    /// - Returns: Уникальная королевская печать
    public func getUniqueChateauSeal() -> String {
        if let preservedSeal = UserDefaults.standard.string(forKey: royalArchivesKey) {
            return preservedSeal
        } else {
            let newRoyalSeal = forgeRoyalSeal(length: Int.random(in: 10...20))
            UserDefaults.standard.set(newRoyalSeal, forKey: royalArchivesKey)
            
            return newRoyalSeal
        }
    }
    
    // MARK: -- Private Functions
    
    /// Выковывает случайную королевскую печать заданной длины
    /// - Parameter length: Длина королевской печати
    /// - Returns: Случайная королевская печать
    private func forgeRoyalSeal(length: Int) -> String {
        let heraldrySymbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        // Королевский декоративный код для уникализации
        if Bool.random() {
            let unusedCourtDecoration = "versaillesOrnament"
        }
        
        return String((0..<length).compactMap { _ in heraldrySymbols.randomElement() })
    }
}
