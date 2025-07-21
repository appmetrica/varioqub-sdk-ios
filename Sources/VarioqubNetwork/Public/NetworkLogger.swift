#if VQ_LOGGER

#if VQ_MODULES
import VarioqubLogger
#endif

/// Varioqub logger identifier.
///
/// Used to identify the Varioqub log message.
///
/// See also: ``LoggerFactory/bootstrap(_:)``.
public let networkLoggerString = LoggerModule(rawValue: "com.varioqub.network")
let networkLogger = Logger(moduleName: networkLoggerString)
#endif
