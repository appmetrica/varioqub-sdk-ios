
public final class UnfairDictionary<Key, Value> where Key: Hashable {
    
    public typealias Key = Key
    public typealias Value = Value
    public typealias Element = (key: Key, value: Value)
    
    private let unfairLock = UnfairLock()
    private var dict: [Key: Value]
    
    public init(_ dict: [Key: Value] = [:]) {
        self.dict = dict
    }

    public subscript(key: Key) -> Value? {
        get { return unfairLock.lock { return dict[key] } }
        set { unfairLock.lock { dict[key] = newValue } }
    }
    
    public func getOrPut(key: Key, putClosure: () throws -> Value) rethrows -> Value {
        return try unfairLock.lock {
            if let value = dict[key] {
                return value
            } else {
                let newValue = try putClosure()
                dict[key] = newValue
                return newValue
            }
        }
    }
    
    public var count: Int {
        return unfairLock.lock { return dict.count }
    }
    
    public func replace(by dictionary: [Key: Value]) {
        unfairLock.lock {
            dict = dictionary
        }
    }
    
    public func removeAll() {
        unfairLock.lock {
            dict.removeAll()
        }
    }
}

extension UnfairDictionary: ExpressibleByDictionaryLiteral {
    
    public convenience init(dictionaryLiteral elements: (Key, Value)...) {
        let dict = Dictionary(uniqueKeysWithValues: elements)
        self.init(dict)
    }
    
}
