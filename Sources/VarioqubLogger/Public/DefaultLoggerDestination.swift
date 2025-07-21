
/// The default logger implementation.
public final class DefaultLoggerDestination: LoggerDestination {

    /// The property that defines.
    public var logLevel: LogLevel? = .info

    /// Initializes the destination.
    public init() {
    }

    /// The log message if ``DefaultLoggerDestination/logLevel`` is more strict than the passed level.
    /// - parameter module: The module name.
    /// - parameter level: The log message level. See ``LogLevel`` for the available log levels.
    /// - parameter message: The message to be logged.
    public func log(module: LoggerModule, level: LogLevel, message: @autoclosure () -> String) {
        if let logLevel = logLevel, level <= logLevel {
            print("\(module.rawValue): \(message())")
        }
    }

    /// The log error if ``DefaultLoggerDestination/logLevel`` is more strict than the passed level.
    /// - parameter module: The module name.
    /// - parameter level: The log message level. See ``LogLevel`` for the available log levels.
    /// - parameter message: The message to be logged.
    public func log(module: LoggerModule, level: LogLevel, error: @autoclosure () -> Error) {
        if let logLevel = logLevel, level <= logLevel {
            print("\(module.rawValue) error: \(error())")
        }
    }
}
