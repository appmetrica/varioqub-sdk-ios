import Foundation

/*
 This module is helper for logging. It provides simple function to enable or disable logger. If configure use `LoggerFactory.bootstrap(_:)` and setup logging
 This module is available in non-spm configuration. SPM configuration uses https://github.com/apple/swift-log library
*/

#if VQ_LOGGER

#if VQ_MODULES
import VarioqubLogger
#endif

let simpleVarioqubLogger = DefaultLoggerDestination()

public func setupVarioqubLogger() {
    LoggerFactory.bootstrap { _ in simpleVarioqubLogger }
}

public func enableVarioqubLogger() {
    simpleVarioqubLogger.logLevel = .info
}

public func disableVarioqubLogger() {
    simpleVarioqubLogger.logLevel = nil
}

/// Varioqub logger identifier.
///
/// Used to identify Varioqub log message.
///
/// See also: ``LoggerFactory/bootstrap(_:)``.
public let varioqubLoggerString = LoggerModule(rawValue: "com.varioqub")
let varioqubLogger = Logger(moduleName: varioqubLoggerString)

#endif
