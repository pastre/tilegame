import CoreGraphics
import TGCore

public protocol CoordinateConverter {
    var radius: CGFloat { get }
    func convert(_ point: CGPoint) -> CGPoint
    func calculateSize() -> CGSize
}

public final class HexagonalCoordinateConverter: CoordinateConverter {
    private let screenSize: CGSize
    private let boardSize: BoardSize

    public var radius: CGFloat {
        screenSize.width / (sqrt(3) * (CGFloat(boardSize.width) + 0.5))
    }
    
    
    public init(screenSize: CGSize, boardSize: BoardSize) {
        self.screenSize = screenSize
        self.boardSize = boardSize
    }
    
    public func convert(_ point: CGPoint) -> CGPoint {
        let width = sqrt(3) * radius
        let height = radius * 2
        
        let yOffset: CGFloat = (height / 4 * point.y)
        
        let xSpacing: CGFloat = 0
        let ySpacing: CGFloat = 0
        
        var x = point.x * width + point.x * xSpacing + width / 2
        let y = point.y * height + point.y * ySpacing + height / 2
        
        if point.y.truncatingRemainder(dividingBy: 2) != 0 {
            x += width / 2
        }

        return .init(
            x: x,
            y: y - yOffset
        )
    }
    
    public func calculateSize() -> CGSize {
        let hexagonHeight = CGFloat(2 * radius)
        let boardHeight = CGFloat(boardSize.height)
        let height =  CGFloat(hexagonHeight * (boardHeight)) - (hexagonHeight / 4) * (boardHeight - 1)
        return .init(width: screenSize.width, height: height)
    }
}
