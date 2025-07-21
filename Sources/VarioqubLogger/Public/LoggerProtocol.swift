/// The struct that represents the module name.
///
/// To use it in logger, see also ``LoggerFactory/bootstrap(_:)``.
public struct LoggerModule: RawRepresentable, CustomStringConvertible, Hashable {
    public var rawValue: String

    /// Initializes the class with a value provided by the rawValue parameter.
    /// - parameter rawValue: The module name string.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public var description: String {
        "LoggerModule(\(rawValue))"
    }
}

/// The enum that represents the logger level.
public enum LogLevel: Int, Comparable {
    /// The message that indicates that an error occurred.
    case error
    /// The message that indicates an unusual behavior which requires special handling.
    case warning
    /// Informational messages.
    case info
    /// The message that contains information helpful for debugging purposes.
    case debug
    /// The message that contains information about the program tracing execution.
    case trace

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

}

/// The protocol that passes the logger message to the logging system.
///
/// See ``LoggerFactory`` to set up a custom implementation.
public protocol LoggerDestination {

    /// The log message.
    /// - parameter module: The module this message originates from.
    /// - parameter level: The message log level.
    /// - parameter message: The message to be logged.
    func log(module: LoggerModule, level: LogLevel, message: @autoclosure () -> String)

    /// The log error.
    /// - parameter module: The module this message originates from.
    /// - parameter level: The message log level.
    /// - parameter error: The error to be logged.
    func log(module: LoggerModule, level: LogLevel, error: @autoclosure () -> Error)
}
