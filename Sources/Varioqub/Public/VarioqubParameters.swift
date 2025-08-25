
/// The struct that represent key-value data.
public struct VarioqubParameters: Equatable {
    private var _data: [String: String] = [:]

    /// Initializes the struct with empty features.
    public init() {
    }

    /// Initializes the struct with a dictionary.
    public init(dictionary: [String : String]) {
        self._data = dictionary
    }
    
    public init(_ pairs: [(String, String)]) {
        self._data = .init(pairs, uniquingKeysWith: { $1 })
    }
    
    /// Returns features dictionary.
    public var dictionary: [String: String] { return _data }
    
    
    public func parameter(for key: String) -> String? {
        return _data[key]
    }
    
    public func hasKey(_ key: String) -> Bool {
        return _data.keys.contains(key)
    }

    /// Adds or replaces the client feature used for experiment filtering.
    /// - parameters feature: The client feature value.
    /// - parameters key: The client feature key.
    public mutating func setParameter(_ param: String, forKey key: String) {
        _data[key] = param
    }

    /// Removes the client feature used for experiment filtering.
    /// - parameters key: The client feature key.
    public mutating func removeParameter(forKey key: String) {
        _data.removeValue(forKey: key)
    }

    /// Appends the client feature with the dictionary.
    /// - parameters other: The dictionary with the client features dictionary.
    public mutating func mergeWith(_ other: [String: String]) {
        _data.merge(other, uniquingKeysWith: { (_ , new) in return new })
    }

    /// Clears all previously added client features.
    public mutating func clearParameters() {
        _data = [:]
    }

}
