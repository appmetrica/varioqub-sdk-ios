
/// The struct that represent key-value data.
public struct VarioqubClientFeatures: Equatable {
    private var _data: [String: String] = [:]

    /// Initializes the struct with empty features.
    public init() {
    }

    /// Initializes the struct with a dictionary.
    public init(dictionary: [String : String]) {
        self._data = dictionary
    }

    /// Returns features dictionary.
    public var features: [String: String] { return _data }

    /// Adds or replaces the client feature used for experiment filtering.
    /// - parameters feature: The client feature value.
    /// - parameters key: The client feature key.
    public mutating func setFeature(_ feature: String, forKey key: String) {
        _data[key] = feature
    }

    /// Removes the client feature used for experiment filtering.
    /// - parameters key: The client feature key.
    public mutating func removeFeature(forKey key: String) {
        _data.removeValue(forKey: key)
    }

    /// Appends the client feature with the dictionary.
    /// - parameters other: The dictionary with the client features dictionary.
    public mutating func mergeWith(_ other: [String: String]) {
        _data.merge(other, uniquingKeysWith: { (_ , new) in return new })
    }

    /// Clears all previously added client features.
    public mutating func clearFeatures() {
        _data = [:]
    }

}

public typealias ClientFeatures = VarioqubClientFeatures
