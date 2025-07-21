
import Foundation

#if VQ_LOGGER

#if VQ_MODULES
import VarioqubLogger
#endif

public typealias VQLoggerModule = String
public typealias VQLoggerBoostrap = (VQLoggerModule) -> VQLoggerDestination

@objc
public class VQLoggerFactory: NSObject {
    
    class func bootstrap(_ f: @escaping VQLoggerBoostrap) {
        LoggerFactory.bootstrap { moduleName in
            let vqProxy = f(moduleName.rawValue)
            let dest = VQLoggerDestinationProxy(proxedDestination: vqProxy)
            return dest
        }
    }
    
}

@objc
public enum VQLogLevel: Int, Equatable, Comparable, CustomStringConvertible {
    case error
    case warning
    case info
    case debug
    case trace

    public static func <(lhs: VQLogLevel, rhs: VQLogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var description: String {
        switch self {
        case .error: return "ERROR"
        case .warning: return "WARNING"
        case .info: return "INFO"
        case .debug: return "DEBUG"
        case .trace: return "TRACE"
        }
    }
}

@objc
public protocol VQLoggerDestination: NSObjectProtocol {
    func isAccepted(module: VQLoggerModule, level: VQLogLevel) -> Bool
    func log(module: VQLoggerModule, level: VQLogLevel, message: String)
    func log(module: VQLoggerModule, level: VQLogLevel, error: NSError)
}

final class VQLoggerDestinationProxy: LoggerDestination {
    
    let proxedDestination: VQLoggerDestination
    init(proxedDestination: VQLoggerDestination) {
        self.proxedDestination = proxedDestination
    }
    
    func log(module: LoggerModule, level: LogLevel, message: @autoclosure () -> String) {
        let vqModule = module.rawValue
        let vqLevel = VQLogLevel(rawValue: level.rawValue)!
        if proxedDestination.isAccepted(module: vqModule, level: vqLevel) {
            proxedDestination.log(module: vqModule, level: vqLevel, message: message())
        }
    }
    
    func log(module: LoggerModule, level: LogLevel, error: @autoclosure () -> Error) {
        let vqModule = module.rawValue
        let vqLevel = VQLogLevel(rawValue: level.rawValue)!
        if proxedDestination.isAccepted(module: vqModule, level: vqLevel) {
            proxedDestination.log(module: vqModule, level: vqLevel, error: error() as NSError)
        }
    }
    
}

#endif
