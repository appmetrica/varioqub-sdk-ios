
/// A struct that defines the flag name.
public struct VarioqubFlag: RawRepresentable, ExpressibleByStringLiteral, Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {
    /// The raw value of the flag name.
    public var rawValue: String

    /// Initializes the class with a value provided by the `rawValue` parameter.
    /// - parameter rawValue: The flag name.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// Initializes the class with a value provided by the value parameter.
    /// - parameter value: The flag name.
    public init(stringLiteral value: String) {
        rawValue = value
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    public var description: String {
        "VarioqubFlag(\(rawValue))"
    }

    public var debugDescription: String { rawValue }
}
