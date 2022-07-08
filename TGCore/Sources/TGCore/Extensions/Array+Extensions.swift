extension Array {
    func randomIndex(where matcher: (Element) -> Bool) -> Int? {
        enumerated()
            .compactMap { i, element in
                matcher(element) ? i : nil
            }
            .randomElement()
    }
    
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count
        else { return nil }
        return self[index]
    }
}
