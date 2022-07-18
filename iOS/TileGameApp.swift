import SwiftUI

@main
struct TileGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}

extension CGSize {
    func square() -> CGSize {
        let sideLenght = min(height, width)
        return .init(width: sideLenght, height: sideLenght)
    }
}
