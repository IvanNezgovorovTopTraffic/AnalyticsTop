import SwiftUI

// MARK: -- FleurDeLisView

/// Королевская лилия с пульсирующим геральдическим эффектом
struct FleurDeLisView: View {
    
    // MARK: -- Public Properties
    
    let royalSize: CGFloat
    let heraldryTint: Color
    let pulseDuration: Double
    
    // MARK: -- Private Properties
    
    @State private var emblemScale: CGFloat = 1.0
    @State private var crownRotation: Double = 0
    
    // MARK: -- Body
    
    var body: some View {
        Image(systemName: "star.fill")
            .font(.system(size: royalSize))
            .foregroundColor(heraldryTint)
            .scaleEffect(emblemScale)
            .rotationEffect(.degrees(crownRotation))
            .onAppear {
                startRoyalAnimation()
            }
    }
    
    // MARK: -- Private Functions
    
    private func startRoyalAnimation() {
        withAnimation(.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
            emblemScale = 1.3
        }
        withAnimation(.linear(duration: pulseDuration * 2).repeatForever(autoreverses: false)) {
            crownRotation = 360
        }
    }
}
