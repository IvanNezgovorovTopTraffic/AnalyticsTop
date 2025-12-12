import SwiftUI

// MARK: -- CastleGateView

/// Величественные врата замка с королевским градиентом и анимированным гербом
struct CastleGateView: View {
    
    // MARK: -- Public Properties
    
    let royalGradientHues: [Color]
    let inscriptionTint: Color
    let heraldryTint: Color
    let welcomeInscription: String
    
    // MARK: -- Private Properties
    
    @State private var drawbridgeRotation: Double = 0
    @State private var torchScale: CGFloat = 1.0
    @State private var bannerOpacity: Double = 0.8
    
    // MARK: -- Body
    
    var body: some View {
        ZStack {
            // Королевский градиентный фон
            LinearGradient(
                gradient: Gradient(colors: royalGradientHues),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Анимированный королевский герб
                ZStack {
                    // Внешний круг герба
                    Circle()
                        .stroke(heraldryTint.opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    // Внутренний вращающийся элемент
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            heraldryTint,
                            style: StrokeStyle(
                                lineWidth: 8,
                                lineCap: .round
                            )
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(drawbridgeRotation))
                        .scaleEffect(torchScale)
                }
                
                // Приветственная надпись
                Text(welcomeInscription)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(inscriptionTint)
                    .opacity(bannerOpacity)
                
                Spacer()
            }
        }
        .onAppear {
            beginCeremony()
        }
    }
    
    // MARK: -- Private Functions
    
    private func beginCeremony() {
        // Анимация вращения герба
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
            drawbridgeRotation = 360
        }
        
        // Анимация пульсации герба
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            torchScale = 1.2
        }
        
        // Анимация мерцания надписи
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            bannerOpacity = 0.3
        }
    }
}
