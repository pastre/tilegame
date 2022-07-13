protocol WeightedEdge {
    associatedtype Vertex
    var cost: Double { get }
    var target: Vertex { get }
}

struct BoardEdge: WeightedEdge {
    var cost: Double { 1 }
    let target: TilePosition
}
