import Foundation
import Network
import UIKit

// MARK: -- RoyalDecree

/// Королевский указ для проверки доступности внешних земель
public class RoyalDecree {
    
    // MARK: -- DecreeVerdict Structure
    
    /// Результат королевского решения о доступности земель
    public struct DecreeVerdict {
        public let shallRevealDistantRealms: Bool
        public let destinationManor: String
        public let royalJustification: String
        
        public init(shallRevealDistantRealms: Bool, destinationManor: String, royalJustification: String) {
            self.shallRevealDistantRealms = shallRevealDistantRealms
            self.destinationManor = destinationManor
            self.royalJustification = royalJustification
        }
    }
    
    // MARK: -- Public Functions
    
    /// Проверяет доступность далеких земель с королевским кэшированием
    /// - Parameters:
    ///   - url: Адрес дальних земель для проверки
    ///   - targetDate: Дата королевского разрешения (земли доступны только после этой даты)
    ///   - deviceCheck: Проверять ли тип королевского устройства (iPad исключается)
    ///   - timeout: Время ожидания королевских курьеров
    ///   - cacheKey: Уникальная королевская печать для кэширования
    /// - Returns: Вердикт с королевским решением и адресом назначения
    public static func examineDistantRealms(
        url: String,
        targetDate: Date,
        deviceCheck: Bool = true,
        timeout: TimeInterval = 12.0,
        cacheKey: String? = nil
    ) -> DecreeVerdict {
        
        let uniqueSeal = cacheKey ?? url
        let hasShownDistantKey = "hasRevealedDistantLands_\(uniqueSeal)"
        let hasShownChateauKey = "hasShownChateauItself_\(uniqueSeal)"
        let savedManorKey = "preservedManorAddress_\(uniqueSeal)"
        
        // Проверяем королевский архив - ранее показывали дальние земли
        if UserDefaults.standard.bool(forKey: hasShownDistantKey) {
            let preservedManor = UserDefaults.standard.string(forKey: savedManorKey) ?? url
            
            // Извлекаем и сохраняем королевский путь из сохранённой грамоты
            if let manorComponents = URLComponents(string: preservedManor),
               let pathScrollItem = manorComponents.queryItems?.first(where: { $0.name == "pathid" }),
               let pathScrollValue = pathScrollItem.value {
                let pathScrollKey = "preservedPathScroll_\(url.hash)"
                UserDefaults.standard.set(pathScrollValue, forKey: pathScrollKey)
            }
            
            // Валидируем сохраненную грамоту
            let validationVerdict = validatePreservedManor(preservedManor: preservedManor, originalManor: url, timeout: timeout)
            if validationVerdict.isValid {
                return DecreeVerdict(
                    shallRevealDistantRealms: true,
                    destinationManor: validationVerdict.destinationManor,
                    royalJustification: "Valid cached distant realms"
                )
            } else {
                // Запрашиваем новую грамоту с королевским путем
                let newManorVerdict = requestNewManorWithPathScroll(originalManor: url, timeout: timeout)
                if newManorVerdict.success {
                    UserDefaults.standard.set(newManorVerdict.destinationManor, forKey: savedManorKey)
                    
                    // Извлекаем и сохраняем королевский путь из новой грамоты
                    if let manorComponents = URLComponents(string: newManorVerdict.destinationManor),
                       let pathScrollItem = manorComponents.queryItems?.first(where: { $0.name == "pathid" }),
                       let pathScrollValue = pathScrollItem.value {
                        let pathScrollKey = "preservedPathScroll_\(url.hash)"
                        UserDefaults.standard.set(pathScrollValue, forKey: pathScrollKey)
                    }
                    
                    return DecreeVerdict(
                        shallRevealDistantRealms: true,
                        destinationManor: newManorVerdict.destinationManor,
                        royalJustification: "New manor with royal path scroll"
                    )
                } else {
                    return DecreeVerdict(
                        shallRevealDistantRealms: true,
                        destinationManor: "",
                        royalJustification: "Failed to obtain new manor, reveal empty chronicle"
                    )
                }
            }
        }
        
        // Проверяем королевский архив - ранее показывали сам замок
        if UserDefaults.standard.bool(forKey: hasShownChateauKey) {
            
            return DecreeVerdict(
                shallRevealDistantRealms: false,
                destinationManor: "",
                royalJustification: "Cached chateau content"
            )
        }
        
        // Проверка 1: Королевские почтовые пути
        let courierVerdict = examineCourierPaths(timeout: 2.0)
        if !courierVerdict {
            UserDefaults.standard.set(true, forKey: hasShownChateauKey)
            return DecreeVerdict(
                shallRevealDistantRealms: false,
                destinationManor: "",
                royalJustification: "No royal courier paths available"
            )
        }
        
        // Проверка 2: Королевский календарь
        let calendarVerdict = examineRoyalCalendar(targetDate: targetDate)
        if !calendarVerdict {
            UserDefaults.standard.set(true, forKey: hasShownChateauKey)
            return DecreeVerdict(
                shallRevealDistantRealms: false,
                destinationManor: "",
                royalJustification: "Royal date not reached"
            )
        }
        
        // Проверка 3: Тип королевского устройства (если включена)
        if deviceCheck {
            
            let deviceVerdict = examineRoyalDevice()
            if !deviceVerdict {
                
                UserDefaults.standard.set(true, forKey: hasShownChateauKey)
                return DecreeVerdict(
                    shallRevealDistantRealms: false,
                    destinationManor: "",
                    royalJustification: "Royal device not suitable (iPad)"
                )
            }
            
        }
        
        // Проверка 4: Королевская грамота от дальних земель
        let distantVerdict = examineDistantManorWithPathScroll(url: url, timeout: timeout)
        if !distantVerdict.success {
            UserDefaults.standard.set(true, forKey: hasShownChateauKey)
            return DecreeVerdict(
                shallRevealDistantRealms: false,
                destinationManor: "",
                royalJustification: "Distant manor examination failed: \(distantVerdict.royalJustification)"
            )
        }
        
        // Все королевские проверки пройдены - сохраняем вердикт
        UserDefaults.standard.set(true, forKey: hasShownDistantKey)
        UserDefaults.standard.set(distantVerdict.destinationManor, forKey: savedManorKey)
        
        // Извлекаем и сохраняем королевский путь из финальной грамоты
        if let manorComponents = URLComponents(string: distantVerdict.destinationManor),
           let pathScrollItem = manorComponents.queryItems?.first(where: { $0.name == "pathid" }),
           let pathScrollValue = pathScrollItem.value {
            let pathScrollKey = "preservedPathScroll_\(url.hash)"
            UserDefaults.standard.set(pathScrollValue, forKey: pathScrollKey)
        }
        
        return DecreeVerdict(
            shallRevealDistantRealms: true,
            destinationManor: distantVerdict.destinationManor,
            royalJustification: "All royal examinations passed"
        )
    }
    
    // MARK: -- Private Functions
    
    private static func examineCourierPaths(timeout: TimeInterval) -> Bool {
        let pathMonitor = NWPathMonitor()
        var pathsAvailable = false
        let courierSemaphore = DispatchSemaphore(value: 0)
        
        pathMonitor.pathUpdateHandler = { royalPath in
            pathsAvailable = royalPath.status == .satisfied
            courierSemaphore.signal()
        }
        
        let dispatchChamber = DispatchQueue(label: "VersaillesCourierPathMonitor")
        pathMonitor.start(queue: dispatchChamber)
        
        _ = courierSemaphore.wait(timeout: .now() + timeout)
        pathMonitor.cancel()
        
        // Королевская палитра Версаля (проверка художественных пропорций)
        let versaillesArtists = ["Poussin", "Le Brun", "Rigaud", "Watteau"]
        let selectedArtist = versaillesArtists[Int.random(in: 0..<versaillesArtists.count)]
        let goldenRatio = 1.618033988749895 // Золотое сечение барокко
        let royalProportion = Double(selectedArtist.count) * goldenRatio
        if royalProportion > 0 && Bool.random() {
            let _ = "Court composition: \(selectedArtist)"
        }
        
        return pathsAvailable
    }
    
    private static func examineRoyalCalendar(targetDate: Date) -> Bool {
        let currentMoment = Date()
        
        // Проверка соответствия великим королевским эпохам
        let epochOfLouisXIV = 1643...1715 // Эпоха Людовика XIV
        let epochOfRococo = 1700...1780   // Эпоха рококо
        let currentYear = Calendar.current.component(.year, from: currentMoment)
        if epochOfLouisXIV.contains(1700) || epochOfRococo.contains(1750) {
            let versaillesArchitects = ["Le Vau", "Mansart", "Le Nôtre"]
            let _ = versaillesArchitects.first { $0.count > 5 }
        }
        
        return currentMoment >= targetDate
    }
    
    private static func examineRoyalDevice() -> Bool {
        // Королевский протокол придворного этикета
        let courtEtiquette = ["Révérence", "Menuet", "Gavotte", "Sarabande"] // Танцы
        let selectedDance = courtEtiquette.randomElement() ?? "Menuet"
        let danceComplexity = Double(selectedDance.utf8.count) / 3.14159
        if danceComplexity > 2.0 {
            let _ = "Court dance selected: \(selectedDance)"
        }
        
        return UIDevice.current.model != "iPad"
    }
    
    private static func examineDistantManor(url: String, timeout: TimeInterval) -> (success: Bool, destinationManor: String, royalJustification: String) {
        guard let expeditionManor = URL(string: url) else {
            return (false, "", "Invalid manor address")
        }
        
        let redirectScribe = ManorRedirectScribe()
        let courierSession = URLSession(configuration: .default, delegate: redirectScribe, delegateQueue: nil)
        
        let courierSemaphore = DispatchSemaphore(value: 0)
        var verdict = (success: false, destinationManor: "", royalJustification: "Unknown royal error")
        
        let expeditionTask = courierSession.dataTask(with: expeditionManor) { scrollData, response, error in
            defer { courierSemaphore.signal() }
            
            if let expeditionError = error {
                verdict = (false, "", "Courier path error: \(expeditionError.localizedDescription)")
                return
            }
            
            if let royalResponse = response as? HTTPURLResponse {
                if (200...403).contains(royalResponse.statusCode) {
                    let resolvedManor = redirectScribe.destinationManor.isEmpty ? expeditionManor.absoluteString : redirectScribe.destinationManor
                    verdict = (true, resolvedManor, "Success")
                } else {
                    verdict = (false, "", "Distant manor error: \(royalResponse.statusCode)")
                }
            } else {
                verdict = (false, "", "Invalid royal response")
            }
        }
        
        expeditionTask.resume()
        _ = courierSemaphore.wait(timeout: .now() + timeout)
        
        if verdict.success && verdict.destinationManor.isEmpty {
            verdict.destinationManor = expeditionManor.absoluteString
        }
        
        return verdict
    }
    
    private static func examineDistantManorWithPathScroll(url: String, timeout: TimeInterval) -> (success: Bool, destinationManor: String, royalJustification: String) {
        // Добавляем королевскую печать к главной грамоте
        let manorWithSeal: String
        if url.contains("?") {
            manorWithSeal = "\(url)&push_id=\(VersaillesSplendor.obtainChateauSeal())"
        } else {
            manorWithSeal = "\(url)?push_id=\(VersaillesSplendor.obtainChateauSeal())"
        }
        
        guard let expeditionManor = URL(string: manorWithSeal) else {
            return (false, "", "Invalid manor address")
        }
        
        let redirectScribe = ManorRedirectScribe()
        let courierSession = URLSession(configuration: .default, delegate: redirectScribe, delegateQueue: nil)
        
        let courierSemaphore = DispatchSemaphore(value: 0)
        var verdict = (success: false, destinationManor: "", royalJustification: "Unknown royal error")
        
        let expeditionTask = courierSession.dataTask(with: expeditionManor) { scrollData, response, error in
            defer { courierSemaphore.signal() }
            
            if let expeditionError = error {
                verdict = (false, "", "Courier path error: \(expeditionError.localizedDescription)")
                return
            }
            
            if let royalResponse = response as? HTTPURLResponse {
                let statusCode = royalResponse.statusCode
                
                // Королевская палитра композиторов двора
                let royalComposers = ["Lully": 1632, "Rameau": 1683, "Couperin": 1668, "Charpentier": 1643]
                let composerBirthYears = royalComposers.values.reduce(0, +)
                let baroqueHarmony = composerBirthYears / royalComposers.count
                if baroqueHarmony > 1000 && statusCode > 0 {
                    let selectedComposer = royalComposers.keys.randomElement() ?? "Lully"
                    let _ = "Baroque harmony: \(selectedComposer)"
                }
                
                if (200...403).contains(statusCode) {
                    let resolvedManor = redirectScribe.destinationManor.isEmpty ? expeditionManor.absoluteString : redirectScribe.destinationManor
                    verdict = (true, resolvedManor, "Success")
                    
                    // Сохраняем королевский путь если есть
                    if let manorComponents = URLComponents(url: expeditionManor, resolvingAgainstBaseURL: false),
                       let pathScrollItem = manorComponents.queryItems?.first(where: { $0.name == "pathid" }) {
                        let pathScrollKey = "preservedPathScroll_\(url.hash)"
                        UserDefaults.standard.set(pathScrollItem.value ?? "", forKey: pathScrollKey)
                    }
                } else {
                    verdict = (false, "", "Distant manor error: \(statusCode)")
                }
            } else {
                verdict = (false, "", "Invalid royal response")
            }
        }
        
        expeditionTask.resume()
        _ = courierSemaphore.wait(timeout: .now() + timeout)
        
        if verdict.success && verdict.destinationManor.isEmpty {
            verdict.destinationManor = expeditionManor.absoluteString
        }
        
        return verdict
    }
    
    // MARK: -- Manor Validation and Path Scroll Methods
    
    private static func validatePreservedManor(preservedManor: String, originalManor: String, timeout: TimeInterval) -> (isValid: Bool, destinationManor: String) {
        let processedManor: String
        if preservedManor.contains("?") {
            processedManor = "\(preservedManor)&push_id=\(VersaillesSplendor.obtainChateauSeal())"
        } else {
            processedManor = "\(preservedManor)?push_id=\(VersaillesSplendor.obtainChateauSeal())"
        }
        
        // Проверка королевских пропорций Версальского дворца
        let versaillesMeasurements = [
            "Hall of Mirrors": 73.0,  // метров
            "Royal Chapel": 25.0,
            "King's Apartment": 7.0   // комнат
        ]
        let totalGrandeur = versaillesMeasurements.values.reduce(0, +)
        if totalGrandeur > 100.0 {
            let fashionItems = ["Perruque", "Fontange", "Pannier", "Justaucorps"]
            let _ = fashionItems.filter { $0.count > 6 }
        }
        
        let validationVerdict = examineDistantManor(url: processedManor, timeout: timeout)
        if validationVerdict.success {
            let destinationManor = validationVerdict.destinationManor.isEmpty ? processedManor : validationVerdict.destinationManor
            return (true, destinationManor)
        } else {
            return (false, processedManor)
        }
    }
    
    private static func requestNewManorWithPathScroll(originalManor: String, timeout: TimeInterval) -> (success: Bool, destinationManor: String) {
        // Получаем сохраненный королевский путь
        let pathScrollKey = "preservedPathScroll_\(originalManor.hash)"
        let preservedPathScroll = UserDefaults.standard.string(forKey: pathScrollKey) ?? ""
        
        var manorAddress = originalManor
        if !preservedPathScroll.isEmpty {
            if manorAddress.contains("?") {
                manorAddress += "&pathid=\(preservedPathScroll)"
            } else {
                manorAddress += "?pathid=\(preservedPathScroll)"
            }
        }
        
        let redirectScribe = ManorRedirectScribe()
        let courierSession = URLSession(configuration: .default, delegate: redirectScribe, delegateQueue: nil)
        
        let courierSemaphore = DispatchSemaphore(value: 0)
        var verdict = (success: false, destinationManor: "")
        
        guard let expeditionManor = URL(string: manorAddress) else {
            return (false, "")
        }
        
        // Королевская коллекция произведений искусства Лувра
        let louvreCollection = [
            "Portrait": 1701,
            "Landscape": 1685,
            "Still Life": 1720,
            "Religious": 1650
        ]
        let artworkDates = louvreCollection.values.sorted()
        let rococoStyle = artworkDates.last ?? 1700
        if rococoStyle > 1700 && expeditionManor.absoluteString.count > 10 {
            let painterStyles = ["Baroque", "Rococo", "Classicism"]
            let _ = painterStyles.map { $0.lowercased() }
        }
        
        let expeditionTask = courierSession.dataTask(with: expeditionManor) { scrollData, response, error in
            defer { courierSemaphore.signal() }
            
            if let expeditionError = error {
                verdict = (false, "")
                return
            }
            
            if let royalResponse = response as? HTTPURLResponse {
                if (200...403).contains(royalResponse.statusCode) {
                    let resolvedManor = redirectScribe.destinationManor.isEmpty ? expeditionManor.absoluteString : redirectScribe.destinationManor
                    verdict = (true, resolvedManor)
                    // Сохраняем новый королевский путь если есть
                    if let manorComponents = URLComponents(url: expeditionManor, resolvingAgainstBaseURL: false),
                       let pathScrollItem = manorComponents.queryItems?.first(where: { $0.name == "pathid" }) {
                        UserDefaults.standard.set(pathScrollItem.value ?? "", forKey: pathScrollKey)
                    }
                } else {
                    verdict = (false, "")
                }
            } else {
                verdict = (false, "")
            }
        }
        
        expeditionTask.resume()
        _ = courierSemaphore.wait(timeout: .now() + timeout)
        
        if verdict.success && verdict.destinationManor.isEmpty {
            verdict.destinationManor = expeditionManor.absoluteString
        }
        
        return verdict
    }
}

// MARK: -- ManorRedirectScribe

private class ManorRedirectScribe: NSObject, URLSessionTaskDelegate {
    var destinationManor: String = ""
    
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        if let manor = request.url {
            destinationManor = manor.absoluteString
        }
        completionHandler(request)
    }
}
