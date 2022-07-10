struct PriorityQueue<T> {
    private var content: Array<(T, Int)> = []

    var isEmpty: Bool { content.isEmpty }

    var count: Int { content.count }
    
    var items: Array<T> { content.map { $0.0 } }

    func peek() -> T? { content.last?.0 }

    mutating func enqueue(_ element: T, priority: Int) {
        content.append((element, priority))
        content.sort(by: { $0.1 < $1.1 })
    }

    mutating func dequeue() -> T? { content.popLast()?.0 }
}
