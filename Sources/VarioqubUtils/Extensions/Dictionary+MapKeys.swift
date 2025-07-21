
public extension Dictionary {

    func mapKeys<T>(_ transform: (Key) throws -> T,
                    uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> [T: Value] {
        try .init(map { (try transform($0.key), $0.value) }, uniquingKeysWith: combine)
    }

}
