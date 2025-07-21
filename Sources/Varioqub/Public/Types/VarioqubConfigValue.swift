/// This protocol specifies that the types using it should be able to convert their forms into a String format.
public protocol StringValueConvertible {
    /// Returns String or nil if the conversion isn't possible.
    var stringValue: String? { get }

    /// Returns String or empty string if conversion isn't possible.
    var stringValueOrDefault: String { get }
}

/// This protocol specifies that the types using it should be able to convert their forms into a Double format.
public protocol DoubleValueConvertible {
    /// Returns Double value or nil if conversion isn't possible.
    var doubleValue: Double? { get }

    /// Returns Double value or 0.0 if conversion isn't possible.
    var doubleValueOrDefault: Double { get }
}

/// This protocol specifies that the types using it should be able to convert their forms into an Int format.
public protocol IntValueConvertible {
    /// Returns Int value or nil if conversion isn't possible.
    var intValue: Int? { get }

    /// Returns Int value or 0 if conversion isn't possible.
    var intValueOrDefault: Int { get }
}

/// This protocol specifies that the types using it should be able to convert their forms into an Int64 format.
public protocol Int64ValueConvertible {
    /// Returns Int64 value or nil if conversion isn't possible.
    var int64Value: Int64? { get }

    /// Returns Int64 value or 0 if conversion isn't possible.
    var int64ValueOrDefault: Int64 { get }
}

/// This protocol specifies that the types using it should be able to convert their forms into a Bool format.
public protocol BoolValueConvertible {
    /// Returns Bool value or nil if conversion isn't possible.
    var boolValue: Bool? { get }

    /// Returns Bool value or false if conversion isn't possible.
    var boolValueOrDefault: Bool { get }
}

/// A struct that defines a configuration value with different sources, such as default, in-app default, or server.
public struct VarioqubConfigValue: Equatable, CustomStringConvertible {

    /// An enum that defines the value source.
    public enum Source {
        /// If no value is provided, the defaults will be used: an empty string ("") for String, 0 for numbers, and false for Bool.
        case defaultValue
        /// The value that is received from defaults.
        /// See ``VarioqubFacade/setDefaults(_:callback:)``, ``VarioqubFacade/loadXml(at:callback:)``.
        case inappDefault
        /// The value that is received from the server.
        case server
    }

    /// The source of this value.
    public var source: Source

    /// The raw value.
    public var value: VarioqubValue?

    /// TestID value Varioqub adds to the triggered test ID set.
    public var triggeredTestID: VarioqubTestID?

    /// Initialize value.
    /// - parameter source: The source of the value.
    /// - parameter value: The raw value.
    /// - parameter triggeredTestID: The triggered test ID value.
    public init(source: Source, value: VarioqubValue?, triggeredTestID: VarioqubTestID?) {
        self.source = source
        self.value = value
        self.triggeredTestID = triggeredTestID
    }

    public var description: String {
        switch self.source {
        case .defaultValue: return ".defaultValue(\(value?.description ?? ""), \(triggeredTestID?.description ?? ""))"
        case .inappDefault: return ".inappDefault(\(value?.description ?? ""), \(triggeredTestID?.description ?? ""))"
        case .server: return ".server(\(value?.description ?? ""), \(triggeredTestID?.description ?? ""))"
        }
    }

}

public extension VarioqubConfigValue {

    /// Returns true if the source is ``Source/defaultValue``.
    var isDefault: Bool {
        switch self.source {
        case .defaultValue: return true
        default: return false
        }
    }

    /// Returns true if the source is ``Source/inappDefault``.
    var isUserDefaults: Bool {
        switch self.source {
        case .inappDefault: return true
        default: return false
        }
    }

    /// Returns true if the source is ``Source/server``.
    var isServer: Bool {
        switch self.source {
        case .server: return true
        default: return false
        }
    }

}

extension VarioqubConfigValue: StringValueConvertible, DoubleValueConvertible, BoolValueConvertible, Int64ValueConvertible, IntValueConvertible {

    /// Returns String or nil if conversion isn't possible.
    public var stringValue: String? {
        return FlagResolverStrategy.selectOptionalValue(configValue: value, userProviderDefaultValue: nil, type: String.self)
    }

    /// Returns String or empty string if conversion isn't possible.
    public var stringValueOrDefault: String {
        return FlagResolverStrategy.selectValue(configValue: value, userProviderDefaultValue: nil, type: String.self)
    }

    /// Returns Double value or nil if conversion isn't possible.
    public var doubleValue: Double? {
        return FlagResolverStrategy.selectOptionalValue(configValue: value, userProviderDefaultValue: nil, type: Double.self)
    }

    /// Returns Double value or 0.0 if conversion isn't possible.
    public var doubleValueOrDefault: Double {
        return FlagResolverStrategy.selectValue(configValue: value, userProviderDefaultValue: nil, type: Double.self)
    }

    /// Returns Bool value or nil if conversion isn't possible.
    public var boolValue: Bool? {
        return FlagResolverStrategy.selectOptionalValue(configValue: value, userProviderDefaultValue: nil, type: Bool.self)
    }

    /// Returns Bool value or false if conversion isn't possible.
    public var boolValueOrDefault: Bool {
        return FlagResolverStrategy.selectValue(configValue: value, userProviderDefaultValue: nil, type: Bool.self)
    }

    /// Returns Int value or nil if conversion isn't possible.
    public var intValue: Int? {
        return FlagResolverStrategy.selectOptionalValue(configValue: value, userProviderDefaultValue: nil, type: Int.self)
    }

    /// Returns Int value or 0 if conversion isn't possible.
    public var intValueOrDefault: Int {
        return FlagResolverStrategy.selectValue(configValue: value, userProviderDefaultValue: nil, type: Int.self)
    }

    /// Returns Int64 value or nil if conversion isn't possible.
    public var int64Value: Int64? {
        return FlagResolverStrategy.selectOptionalValue(configValue: value, userProviderDefaultValue: nil, type: Int64.self)
    }

    /// Returns Int64 value or 0 if conversion isn't possible.
    public var int64ValueOrDefault: Int64 {
        return FlagResolverStrategy.selectValue(configValue: value, userProviderDefaultValue: nil, type: Int64.self)
    }

}
