import Foundation

final class BoardBuilder {
    private var tiles: [[Tile]]
    private var size: BoardSize
    
    init(size: BoardSize) {
        self.size = size
        self.tiles = .init(
            repeating: .init(
                repeating: .empty,
                count: size.width
            ),
            count: size.height
        )
    }
    
    func fill(withTile tile: Tile) -> BoardBuilder {
        tiles = tiles.map {
            .init(repeating: tile, count: $0.count)
        }
        return self
    }
    
    func withExitBorder() -> BoardBuilder {
        guard tiles.area > 0
        else { return self }
        
        tiles[tiles.startIndex] = .init(repeating: .exit, count: tiles.width)
        tiles[tiles.endIndex - 1] = .init(repeating: .exit, count: tiles.width)
        for i in 0..<tiles.height  {
            tiles[i][tiles[i].startIndex] = .exit
            tiles[i][tiles[i].endIndex - 1] = .exit
        }
        
        return self
    }
    
    func removing(_ tile: Tile, percent: Float) -> BoardBuilder {
        let tileToSet: Tile = tile == .empty ? .floor : .empty
        let totalCount = tiles.reduce(into: 0) {
            $0 += $1.filter { $0 == tile }.count
        }
        
        var toRemoveCount = Int(Float(totalCount) * percent)
        while toRemoveCount > 0 {
            guard let randomRow = tiles.randomIndex(where: { $0.contains(tile) }),
                  let randomTile = tiles[randomRow].randomIndex(where: { $0 == tile })
            else { return self }
        
            tiles[randomRow][randomTile] = tileToSet
            toRemoveCount -= 1
        }
        
        return self
    }
    
    func board() -> Board {
        .init(rows: tiles, size: size)
    }
}

extension Board {
    init(rows: [[Tile]]) {
        self.init(
            rows: rows,
            size: .init(
                width: rows.width,
                height: rows.height
            ))
    }
}


private extension Array where Element == [Tile] {
    var width: Int {
        first?.count ?? 0
    }
    var height: Int {
        count
    }
    var area: Int { height * width }
}
