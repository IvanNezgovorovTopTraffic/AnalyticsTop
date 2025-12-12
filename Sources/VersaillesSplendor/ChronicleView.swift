import SwiftUI
import WebKit
import UIKit
import StoreKit

// MARK: -- ChronicleView

/// Королевская хроника для отображения далеких земель через веб-портал
public struct ChronicleView: UIViewRepresentable {
    
    // MARK: -- Public Properties
    
    let manuscriptAddress: String
    let allowsCourtGestures: Bool
    let enableManuscriptRefresh: Bool
    
    // MARK: -- Init
    
    public init(manuscriptAddress: String, allowsCourtGestures: Bool = true, enableManuscriptRefresh: Bool = true) {
        self.manuscriptAddress = manuscriptAddress
        self.allowsCourtGestures = allowsCourtGestures
        self.enableManuscriptRefresh = enableManuscriptRefresh
    }
    
    // MARK: -- UIViewRepresentable
    
    public func makeUIView(context: Context) -> WKWebView {
        let chronicleConfiguration = WKWebViewConfiguration()
        let manuscriptPreferences = WKWebpagePreferences()
        
        // Настройка королевских скриптов
        manuscriptPreferences.allowsContentJavaScript = true
        chronicleConfiguration.defaultWebpagePreferences = manuscriptPreferences
        chronicleConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // Настройка королевских медиа
        chronicleConfiguration.allowsInlineMediaPlayback = true
        chronicleConfiguration.mediaTypesRequiringUserActionForPlayback = []
        chronicleConfiguration.allowsAirPlayForMediaPlayback = true
        chronicleConfiguration.allowsPictureInPictureMediaPlayback = true
        
        // Настройка хранилища королевских свитков
        chronicleConfiguration.websiteDataStore = WKWebsiteDataStore.default()
        
        // Создание королевской хроники
        let manuscriptPortal = WKWebView(frame: .zero, configuration: chronicleConfiguration)
        
        // Настройка королевского фона (черный)
        manuscriptPortal.backgroundColor = .black
        manuscriptPortal.scrollView.backgroundColor = .black
        manuscriptPortal.isOpaque = false
        
        // Настройка придворных жестов
        manuscriptPortal.allowsBackForwardNavigationGestures = allowsCourtGestures
        
        // Используем Desktop Safari User Agent для прохождения королевской OAuth аутентификации
        // Desktop версия обходит блокировку "embedded browsers"
        manuscriptPortal.customUserAgent =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 18_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"
        
        // Настройка королевского координатора
        manuscriptPortal.navigationDelegate = context.coordinator
        manuscriptPortal.uiDelegate = context.coordinator
        
        // Настройка обновления хроники
        let manuscriptRefreshControl = UIRefreshControl()
        manuscriptRefreshControl.tintColor = .white
        manuscriptRefreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.refreshManuscript(_:)), for: .valueChanged)
        manuscriptPortal.scrollView.refreshControl = manuscriptRefreshControl
        
        // Сохраняем королевские ссылки в координаторе
        context.coordinator.royalChroniclePortal = manuscriptPortal
        context.coordinator.manuscriptRefreshControl = manuscriptRefreshControl
        
        if let manuscriptDestination = URL(string: manuscriptAddress) {
            manuscriptPortal.load(URLRequest(url: manuscriptDestination))
        }
        
        return manuscriptPortal
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // ⚠️ НЕ перезагружаем на каждый королевский апдейт SwiftUI
        // Загружаем только если действительно сменился адрес манускрипта
        if uiView.url?.absoluteString != manuscriptAddress, let manuscriptDestination = URL(string: manuscriptAddress) {
            uiView.load(URLRequest(url: manuscriptDestination))
        }
    }
    
    public func makeCoordinator() -> RoyalScribe {
        RoyalScribe(self)
    }
    
    // MARK: -- RoyalScribe
    
    public class RoyalScribe: NSObject, WKNavigationDelegate, WKUIDelegate {
        
        // MARK: -- Public Properties
        
        var parentChronicle: ChronicleView
        weak var royalChroniclePortal: WKWebView?
        weak var manuscriptRefreshControl: UIRefreshControl?
        var temporaryOAuthPortal: WKWebView? // Временный портал для королевской OAuth
        
        // MARK: -- Init
        
        init(_ parentChronicle: ChronicleView) {
            self.parentChronicle = parentChronicle
            super.init()
            
            // Настройка королевских наблюдателей за событиями придворной клавиатуры
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(royalKeyboardWillAppear),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(royalKeyboardDidAppear),
                name: UIResponder.keyboardDidShowNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(royalKeyboardWillDisappear),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(royalKeyboardDidDisappear),
                name: UIResponder.keyboardDidHideNotification,
                object: nil
            )
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        // MARK: -- Public Functions
        
        @objc func refreshManuscript(_ sender: UIRefreshControl) {
            royalChroniclePortal?.reload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.manuscriptRefreshControl?.endRefreshing()
            }
        }
        
        // MARK: -- Keyboard Handling
        
        // Мягкое обновление королевского viewport без изменения свитков
        private func gentleViewportRefresh() {
            guard let chroniclePortal = royalChroniclePortal else { return }
            
            // Легкие королевские скрипты - только события, без изменения свитков
            let royalScript = """
            (function() {
                // Триггер viewport и window resize событий
                if (window.visualViewport) {
                    window.dispatchEvent(new Event('resize'));
                }
                window.dispatchEvent(new Event('resize'));
                
                // Легкий scroll для триггера reflow
                window.scrollBy(0, 1);
                window.scrollBy(0, -1);
            })();
            """
            
            chroniclePortal.evaluateJavaScript(royalScript, completionHandler: nil)
            
            // Легкий нативный королевский scroll
            let currentScrollPosition = chroniclePortal.scrollView.contentOffset
            chroniclePortal.scrollView.setContentOffset(
                CGPoint(x: currentScrollPosition.x, y: currentScrollPosition.y + 1),
                animated: false
            )
            chroniclePortal.scrollView.setContentOffset(currentScrollPosition, animated: false)
        }
        
        @objc private func royalKeyboardWillAppear(_ notification: Notification) {
            gentleViewportRefresh()
        }
        
        @objc private func royalKeyboardDidAppear(_ notification: Notification) {
            // Отложенное обновление после полного появления придворной клавиатуры
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.gentleViewportRefresh()
            }
        }
        
        @objc private func royalKeyboardWillDisappear(_ notification: Notification) {
            gentleViewportRefresh()
        }
        
        @objc private func royalKeyboardDidDisappear(_ notification: Notification) {
            // Немедленное обновление
            gentleViewportRefresh()
            
            // Вторая попытка после задержки
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.gentleViewportRefresh()
            }
            
            // Третья попытка после длинной задержки для упорных случаев
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.gentleViewportRefresh()
            }
        }
        
        // MARK: -- Navigation Handling
        
        // Обработка королевской навигации
        public func webView(_ webView: WKWebView,
                            decidePolicyFor action: WKNavigationAction,
                            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let manuscriptDestination = action.request.url {
                let destinationAddress = manuscriptDestination.absoluteString
                
                // Если это временный королевский портал - перехватываем РЕАЛЬНЫЙ адрес здесь!
                if webView == temporaryOAuthPortal {
                    if !destinationAddress.isEmpty && 
                       destinationAddress != "about:blank" &&
                       !destinationAddress.hasPrefix("about:") {
                        // Загружаем в главный королевский портал
                        if let mainPortal = royalChroniclePortal {
                            mainPortal.load(URLRequest(url: manuscriptDestination))
                            temporaryOAuthPortal = nil
                        }
                        decisionHandler(.cancel)
                        return
                    }
                }
                
                let addressScheme = manuscriptDestination.scheme?.lowercased()
                
                // Открываем внешние схемы в королевской системе
                if let scheme = addressScheme,
                   scheme != "http", scheme != "https", scheme != "about" {
                    UIApplication.shared.open(manuscriptDestination, options: [:], completionHandler: nil)
                    decisionHandler(.cancel)
                    return
                }
                
                // OAuth popup - загружаем в том же портале (со свайпом назад)
                if action.targetFrame == nil {
                    webView.load(URLRequest(url: manuscriptDestination))
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
        
        // Обработка дочерних королевских окон - перехватываем адрес для главного портала
        public func webView(_ webView: WKWebView,
                            createWebViewWith configuration: WKWebViewConfiguration,
                            for navAction: WKNavigationAction,
                            windowFeatures: WKWindowFeatures) -> WKWebView? {
            
            // Если адрес есть - загружаем в текущий королевский портал
            if let manuscriptDestination = navAction.request.url, 
               !manuscriptDestination.absoluteString.isEmpty,
               manuscriptDestination.absoluteString != "about:blank" {
                webView.load(URLRequest(url: manuscriptDestination))
                return nil
            }
            
            // Если адрес пустой - создаем СКРЫТЫЙ временный королевский портал
            // Он перехватит адрес, который загрузят королевские скрипты, и передаст в главный портал
            let temporaryPortal = WKWebView(frame: .zero, configuration: configuration)
            temporaryPortal.navigationDelegate = self
            temporaryPortal.uiDelegate = self
            temporaryPortal.isHidden = true
            
            self.temporaryOAuthPortal = temporaryPortal
            return temporaryPortal
        }
        
        // Закрытие временного королевского портала
        public func webViewDidClose(_ webView: WKWebView) {
            if webView == temporaryOAuthPortal {
                temporaryOAuthPortal = nil
            }
        }
        
        // Обработка начала королевской навигации
        public func webView(_ chroniclePortal: WKWebView, didStartProvisionalNavigation royalNavigation: WKNavigation!) {
            // Если это временный портал - перехватываем РЕАЛЬНЫЙ адрес (не about:blank)
            if chroniclePortal == temporaryOAuthPortal, let realDestination = chroniclePortal.url {
                let destinationAddress = realDestination.absoluteString
                
                // Игнорируем пустые адреса и about:blank
                if !destinationAddress.isEmpty && 
                   destinationAddress != "about:blank" &&
                   !destinationAddress.hasPrefix("about:") {
                    // Загружаем в главный королевский портал
                    if let mainPortal = royalChroniclePortal {
                        mainPortal.load(URLRequest(url: realDestination))
                        temporaryOAuthPortal = nil
                    }
                    return
                }
            }
        }
        
        // Обработка завершения королевской загрузки
        public func webView(_ chroniclePortal: WKWebView, didFinish royalNavigation: WKNavigation!) {
            manuscriptRefreshControl?.endRefreshing()
        }
        
        // Обработка королевских ошибок загрузки
        public func webView(_ chroniclePortal: WKWebView, didFail royalNavigation: WKNavigation!, withError royalError: Error) {
            manuscriptRefreshControl?.endRefreshing()
        }
        
        // Обработка ошибок загрузки (предварительная королевская навигация)
        public func webView(_ chroniclePortal: WKWebView, didFailProvisionalNavigation royalNavigation: WKNavigation!, withError royalError: Error) {
            // Обработка королевских ошибок
        }
    }
}

// MARK: -- SafeChronicleView

/// SwiftUI обертка для королевской хроники с отступами от безопасной зоны
public struct SafeChronicleView: View {
    
    // MARK: -- Public Properties
    
    let manuscriptAddress: String
    let allowsCourtGestures: Bool
    let enableManuscriptRefresh: Bool
    
    // MARK: -- Init
    
    public init(manuscriptAddress: String, allowsCourtGestures: Bool = true, enableManuscriptRefresh: Bool = true) {
        self.manuscriptAddress = manuscriptAddress
        self.allowsCourtGestures = allowsCourtGestures
        self.enableManuscriptRefresh = enableManuscriptRefresh
    }
    
    // MARK: -- Body
    
    public var body: some View {
        ZStack {
            // Королевский черный фон
            Color.black
                .ignoresSafeArea()
            
            // Хроника с отступами от безопасной зоны
            ChronicleView(
                manuscriptAddress: manuscriptAddress,
                allowsCourtGestures: allowsCourtGestures,
                enableManuscriptRefresh: enableManuscriptRefresh
            )
            .ignoresSafeArea(.keyboard)
            .onAppear {
               
                
                // Запрос королевской оценки при третьем посещении
                let expeditionCount = UserDefaults.standard.integer(forKey: "versaillesSplendorExpeditionCount")
                if expeditionCount == 2 {
                    if let throneRoom = UIApplication.shared
                        .connectedScenes
                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: throneRoom)
                    }
                }
            }
        }
    }
}
