import SpriteKit

#if os(iOS) || os(tvOS)
extension GameScene {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches
            .map { $0.location(in: self) }
            .forEach(handleTouch)
    }
}
#endif

#if os(OSX)
extension GameScene {
    override func mouseUp(with event: NSEvent) {
        let position = event.location(in: self)
        handleTouch(atPosition: position)
    }
}
#endif

private extension GameScene {
    func handleTouch(atPosition position: CGPoint) {
        print("TOCOU", position)
    }
}
