import Foundation

final class AStar<G: Graph> {
    private let graph: G
    private let heuristic: (G.Vertex, G.Vertex) -> Double

    private var open: HashedHeap<Node<G.Vertex>>
    private var closed = Set<G.Vertex>()
    private var costs = Dictionary<G.Vertex, Double>()
    private var parents = Dictionary<G.Vertex, G.Vertex>()
    
    init(graph: G, heuristic: @escaping (G.Vertex, G.Vertex) -> Double) {
        self.graph = graph
        self.heuristic = heuristic
        open = HashedHeap(sort: <)
    }

    func path(start: G.Vertex, target: G.Vertex) -> [G.Vertex] {
        open.insert(Node<G.Vertex>(vertex: start, cost: 0, estimate: heuristic(start, target)))
        while !open.isEmpty {
            guard let node = open.remove() else {
                break
            }
            costs[node.vertex] = node.cost

            if (node.vertex == target) {
                let path = buildPath(start: start, target: target)
                cleanup()
                return path
            }

            if !closed.contains(node.vertex) {
                expand(node: node, target: target)
                closed.insert(node.vertex)
            }
        }

        return []
    }

    private func expand(node: Node<G.Vertex>, target: G.Vertex) {
        let edges = graph.edgesOutgoing(from: node.vertex)
        for edge in edges {
            let g = cost(node.vertex) + edge.cost
            if g < cost(edge.target) {
                open.insert(Node<G.Vertex>(vertex: edge.target, cost: g, estimate: heuristic(edge.target, target)))
                parents[edge.target] = node.vertex
            }
        }
    }

    private func cost(_ vertex: G.Edge.Vertex) -> Double {
        if let c = costs[vertex] {
            return c
        }

        let node = Node(vertex: vertex, cost: Double.greatestFiniteMagnitude, estimate: 0)
        if let index = open.index(of: node) {
            return open[index].cost
        }

        return Double.greatestFiniteMagnitude
    }

    private func buildPath(start: G.Vertex, target: G.Vertex) -> [G.Vertex] {
        var path = Array<G.Vertex>()
        path.append(target)

        var current = target
        while current != start {
            guard let parent = parents[current]
            else { return [] }
            current = parent
            path.append(current)
        }

        return path.reversed()
    }

    private func cleanup() {
        open.removeAll()
        closed.removeAll()
        parents.removeAll()
    }
}

private struct Node<V: Hashable>: Hashable, Comparable {
    var vertex: V
    var cost: Double
    var estimate: Double

    init(vertex: V, cost: Double, estimate: Double) {
        self.vertex = vertex
        self.cost = cost
        self.estimate = estimate
    }

    static func < (lhs: Node<V>, rhs: Node<V>) -> Bool {
        return lhs.cost + lhs.estimate < rhs.cost + rhs.estimate
    }

    static func == (lhs: Node<V>, rhs: Node<V>) -> Bool {
        return lhs.vertex == rhs.vertex
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(vertex.hashValue)
    }
}
