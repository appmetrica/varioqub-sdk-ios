/// The VarioqubValue struct that stores a String value or converts this string to different data types: String, Boolean, Double, Integer, and 64-bit Integer.
public struct VarioqubValue: Equatable, CustomStringConvertible {
    public let rawValue: String

    public init(string: String) {
        rawValue = string
    }

    /// This property returns the rawValue as a String value.
    public var stringValue: String? {
        rawValue
    }

    /// This property tries to convert rawValue to boolean and returns it if possible, or nil if the conversion is not possible.
    public var boolValue: Bool? {
        Bool(string: rawValue)
    }

    /// This property tries to convert rawValue to double and returns it if possible, or nil if the conversion is not possible.
    public var doubleValue: Double? {
        Double(rawValue)
    }

    /// This property tries to convert rawValue to integer and returns it if possible, or nil if the conversion is not possible.
    public var intValue: Int? {
        Int(rawValue)
    }

    /// This property tries to convert rawValue to 64-bit integer and returns it if possible, or nil if the conversion is not possible.
    public var int64Value: Int64? {
        Int64(rawValue)
    }

    public var description: String {
        "Value(\(rawValue))"
    }
}

/// This protocol creates a specific value of type VarioqubValue.
public protocol VarioqubInitializableByValue {
    /// Initializes the type with the ``VarioqubValue`` value.
    init?(value: VarioqubValue)

    /// The default value for the type.
    static var defaultValue: Self { get }
}

extension Int: VarioqubInitializableByValue {

    /// Initializes an Int with the ``VarioqubValue`` value.
    public init?(value: VarioqubValue) {
        if let v = Int(value.rawValue) {
            self = v
        } else {
            return nil
        }
    }

    /// The default value for the Int type.
    public static var defaultValue: Int { ConfigValueDefaultConstants.intValue }
}

extension Int64: VarioqubInitializableByValue {

    /// Initializes an Int64 with the ``VarioqubValue`` value.
    public init?(value: VarioqubValue) {
        if let v = Int64(value.rawValue) {
            self = v
        } else {
            return nil
        }
    }

    /// The default value for the Int64 type.
    public static var defaultValue: Int64 { ConfigValueDefaultConstants.int64Value }
}

extension String: VarioqubInitializableByValue {

    /// Initializes a String with the ``VarioqubValue`` value.
    public init(value: VarioqubValue) {
        self = value.rawValue
    }

    /// The default value for the String type.
    public static var defaultValue: String { ConfigValueDefaultConstants.stringValue }
}

extension Double: VarioqubInitializableByValue {

    /// Initializes a Double with the ``VarioqubValue`` value.
    public init?(value: VarioqubValue) {
        if let v = Double(value.rawValue) {
            self = v
        } else {
            return nil
        }
    }

    /// The default value for the Double type.
    public static var defaultValue: Double { ConfigValueDefaultConstants.doubleValue }
}

extension Bool: VarioqubInitializableByValue {

    /// Initializes a Bool with the ``VarioqubValue`` value.
    public init?(value: VarioqubValue) {
        if let b = Bool(string: value.rawValue) {
            self = b
        } else {
            return nil
        }
    }

    /// The default value for the Bool type.
    public static var defaultValue: Bool { ConfigValueDefaultConstants.boolValue }
}
