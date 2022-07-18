import CoreGraphics

extension CGFloat {
    var decimalPart: CGFloat {
        self - self.rounded(.down)
    }
}
