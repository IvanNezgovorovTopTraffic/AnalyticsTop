import SwiftUI

// MARK: -- TapestryView

/// Королевский гобелен с движущимися узорами
struct TapestryView: View {
    
    // MARK: -- Public Properties
    
    let threadCount: Int
    let weavingSpeed: Double
    
    // MARK: -- Private Properties
    
    @State private var embroideryThreads: [TapestryThread] = []
    
    // MARK: -- TapestryThread Structure
    
    struct TapestryThread: Identifiable {
        let id = UUID()
        let positionX: CGFloat
        let positionY: CGFloat
        let threadThickness: CGFloat
        let luminosity: Double
    }
    
    // MARK: -- Body
    
    var body: some View {
        GeometryReader { grandHall in
            ZStack {
                Color.black
                
                ForEach(embroideryThreads) { thread in
                    Circle()
                        .fill(Color.white)
                        .frame(width: thread.threadThickness, height: thread.threadThickness)
                        .opacity(thread.luminosity)
                        .position(x: thread.positionX, y: thread.positionY)
                }
            }
            .onAppear {
                weaveThreads(in: grandHall.size)
                animateTapestry()
            }
        }
    }
    
    // MARK: -- Private Functions
    
    private func weaveThreads(in canvasSize: CGSize) {
        embroideryThreads = (0..<threadCount).map { _ in
            TapestryThread(
                positionX: CGFloat.random(in: 0...canvasSize.width),
                positionY: CGFloat.random(in: 0...canvasSize.height),
                threadThickness: CGFloat.random(in: 1...3),
                luminosity: Double.random(in: 0.3...1.0)
            )
        }
    }
    
    private func animateTapestry() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            withAnimation(.linear(duration: 0.1)) {
                for threadIdx in embroideryThreads.indices {
                    embroideryThreads[threadIdx] = TapestryThread(
                        positionX: embroideryThreads[threadIdx].positionX + CGFloat(weavingSpeed),
                        positionY: embroideryThreads[threadIdx].positionY,
                        threadThickness: embroideryThreads[threadIdx].threadThickness,
                        luminosity: embroideryThreads[threadIdx].luminosity
                    )
                    
                    // Перемещаем нити, которые вышли за границы полотна
                    if embroideryThreads[threadIdx].positionX > 1000 {
                        embroideryThreads[threadIdx] = TapestryThread(
                            positionX: -10,
                            positionY: embroideryThreads[threadIdx].positionY,
                            threadThickness: embroideryThreads[threadIdx].threadThickness,
                            luminosity: embroideryThreads[threadIdx].luminosity
                        )
                    }
                }
            }
        }
    }
}
