protocol Graph {
    associatedtype Vertex: Hashable
    associatedtype Edge: WeightedEdge where Edge.Vertex == Vertex

    /// Lists all edges going out from a vertex.
    func edgesOutgoing(from vertex: Vertex) -> [Edge]
}

extension Board: Graph {
    func edgesOutgoing(from vertex: TilePosition) -> [BoardEdge] {
        vertex.surroundings
            .filter {
                contains(position: $0) &&
                self[$0] != .empty
            }
            .map(BoardEdge.init)
    }
}
