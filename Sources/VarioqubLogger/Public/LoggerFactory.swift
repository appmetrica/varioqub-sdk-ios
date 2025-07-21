
import Darwin

/// The type for the logger bootstrap.
public typealias LoggerBootstrap = (LoggerModule) -> LoggerDestination

/// Class for configuring logger
///
/// This allow user to intergrate logger into application by setup via ``LoggerFactory/bootstrap(_:)``
///
/// See also ``DefaultLoggerDestination`` to use default logger
final public class LoggerFactory {

    static var _bootstrap: LoggerBootstrap = { _ in DefaultLoggerDestination() }

    /// It's one-time configuration function to select logger implementation
    ///
    /// This method should be called before using Varioqub.
    /// Each varioqub module call bootstrap only once, so the best place is before calling ``VarioqubFacade/initialize(clientId:config:idProvider:reporter:)``.
    ///
    ///
    /// Default implementation uses ``DefaultLoggerDestination`` to print log messages
    ///
    /// - parameter f: function that return ``LoggerDestination`` for  ``LoggerModule`` identifier. You can setup custom logger for each module
    static public func bootstrap(_ f: @escaping LoggerBootstrap) {
        _bootstrap = f
    }

}
