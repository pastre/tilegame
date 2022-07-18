import CoreGraphics

extension CGPath {
    static func hexagon(radius: CGFloat) -> CGPath {
        let sides: CGFloat = 6
        let path = CGMutablePath()
        
        var points = [CGPoint]()
        
        for i in stride(from: 0.0, through: sides - 1, by: 1) {
            
            let angle = .pi / 180 * (60 * i - 30)
            let pX = radius * cos(angle)
            let pY = radius * sin(angle)
            
            points.append(CGPoint(x: pX, y: pY))
        }
        
        path.addLines(between: points)
        path.closeSubpath()
        return path.copy()!
    }
}
