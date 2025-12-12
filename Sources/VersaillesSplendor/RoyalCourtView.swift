import SwiftUI

// MARK: -- RoyalCourtView

/// Королевский двор с вращающимися придворными
struct RoyalCourtView: View {
    
    // MARK: -- Public Properties
    
    let courtierCount: Int
    let chamberSize: CGFloat
    let royalPalette: [Color]
    
    // MARK: -- Private Properties
    
    @State private var courtRotation: Double = 0
    
    // MARK: -- Body
    
    var body: some View {
        ZStack {
            ForEach(0..<courtierCount, id: \.self) { courtierIndex in
                Circle()
                    .fill(royalPalette[courtierIndex % royalPalette.count])
                    .frame(width: 20, height: 20)
                    .offset(x: chamberSize * 0.4)
                    .rotationEffect(.degrees(Double(courtierIndex) * 360.0 / Double(courtierCount)))
                    .rotationEffect(.degrees(courtRotation))
            }
        }
        .frame(width: chamberSize, height: chamberSize)
        .onAppear {
            startCourtDance()
        }
    }
    
    // MARK: -- Private Functions
    
    private func startCourtDance() {
        withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: false)) {
            courtRotation = 360
        }
    }
}
