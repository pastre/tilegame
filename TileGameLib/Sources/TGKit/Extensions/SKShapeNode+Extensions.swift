import SpriteKit

extension SKShapeNode {
    convenience init(hexagonOfRadius radius: CGFloat) {
        self.init(path: .hexagon(radius: radius))
        lineWidth = 0
    }
}
