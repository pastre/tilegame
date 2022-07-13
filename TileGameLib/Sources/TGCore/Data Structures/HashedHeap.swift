import Foundation

struct HashedHeap<T: Hashable> {
    private var elements = [T]()
    private var indices = [T: Int]()
    private var isOrderedBefore: (T, T) -> Bool

    init(sort: @escaping (T, T) -> Bool) {
        isOrderedBefore = sort
    }

    var isEmpty: Bool { elements.isEmpty }

    subscript(index: Int) -> T { elements[index] }

    func index(of element: T) -> Int? { indices[element] }

    mutating func insert(_ value: T) {
        elements.append(value)
        indices[value] = elements.count - 1
        shiftUp(elements.count - 1)
    }

    @discardableResult
    mutating func remove() -> T? {
        if elements.isEmpty { return nil }
        if elements.count == 1 { return removeLast() }
        let value = elements[0]
        set(removeLast(), at: 0)
        shiftDown()
        return value
    }

    mutating func removeAll() {
        elements.removeAll()
        indices.removeAll()
    }

    mutating func removeLast() -> T {
        guard let value = elements.last else {
        preconditionFailure("Trying to remove element from empty heap")
        }
        indices[value] = nil
        return elements.removeLast()
    }

    mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = elements[childIndex]
        var parentIndex = self.parentIndex(of: childIndex)
        while childIndex > 0 && isOrderedBefore(child, elements[parentIndex]) {
            set(elements[parentIndex], at: childIndex)
            childIndex = parentIndex
            parentIndex = self.parentIndex(of: childIndex)
        }
        set(child, at: childIndex)
    }
    
    mutating func shiftDown() {
        shiftDown(0, heapSize: elements.count)
    }

    mutating func shiftDown(_ index: Int, heapSize: Int) {
        var parentIndex = index
        
        while true {
            let leftChildIndex = self.leftChildIndex(of: parentIndex)
            let rightChildIndex = leftChildIndex + 1
            var first = parentIndex
            
            if leftChildIndex < heapSize && isOrderedBefore(elements[leftChildIndex], elements[first]) {
                first = leftChildIndex
            }
            
            if rightChildIndex < heapSize && isOrderedBefore(elements[rightChildIndex], elements[first]) {
                first = rightChildIndex
            }
            
            if first == parentIndex { return }

            swapAt(parentIndex, first)
            parentIndex = first
        }
    }

    private mutating func set(_ newValue: T, at index: Int) {
        indices[elements[index]] = nil
        elements[index] = newValue
        indices[newValue] = index
    }

    private mutating func swapAt(_ i: Int, _ j: Int) {
        elements.swapAt(i, j)
        indices[elements[i]] = i
        indices[elements[j]] = j
    }

    private func parentIndex(of index: Int) -> Int { (index - 1) / 2 }

    private func leftChildIndex(of index: Int) -> Int { 2*index + 1 }
}
