import SpriteKit

extension GameScene {
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif
}

private extension GameScene {
    func setUpScene() {
        let label = SKLabelNode()
        
        backgroundColor = .red
        addChild(label)
        
        label.position = frame.center
        label.attributedText = NSAttributedString(string: "SALVE DE LA", attributes: [
            .font: NSFont.systemFont(ofSize: 30, weight: .bold),
            .foregroundColor: NSColor.blue
        ])
    }
    
}

extension CGRect {
    var center: CGPoint {
        .init(x: midX, y: midY)
    }
}
