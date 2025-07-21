
/// The VarioqubTestID struct that represents the test ID.
public struct VarioqubTestID: RawRepresentable, ExpressibleByIntegerLiteral, Equatable, Hashable, CustomStringConvertible {
    /// The raw value of the test ID.
    public var rawValue: Int64

    /// Initializes the class with a value provided by the `rawValue` parameter.
    /// - parameter rawValue: The test ID.
    public init(rawValue: Int64) {
        self.rawValue = rawValue
    }

    /// Initializes the class with a value provided by the value parameter.
    /// - parameter value: The test ID.
    public init(integerLiteral value: Int64) {
        rawValue = value
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }

    public var description: String {
        "VarioqubTestID(\(rawValue))"
    }
}
