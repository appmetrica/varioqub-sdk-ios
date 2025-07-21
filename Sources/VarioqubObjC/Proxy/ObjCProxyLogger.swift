
import Foundation

#if VQ_MODULES && VQ_LOGGER
import VarioqubLogger
#endif

#if VQ_LOGGER
final class ObjCProxyLogger: LoggerDestination {
    let destination: VQLoggerDestination

    init(destination: VQLoggerDestination) {
        self.destination = destination
    }

    func log(module: LoggerModule, level: LogLevel, message: @autoclosure () -> String) {
        let cvModule = module.rawValue
        let cvLevel = level.vqLogLevel
        if destination.isAccepted(module: cvModule, level: cvLevel) {
            destination.log(module: cvModule, level: cvLevel, message: message())
        }
    }

    func log(module: LoggerModule, level: LogLevel, error: @autoclosure () -> Error) {
        let cvModule = module.rawValue
        let cvLevel = level.vqLogLevel
        if destination.isAccepted(module: cvModule, level: cvLevel) {
            destination.log(module: module.rawValue, level: level.vqLogLevel, error: makeVQError(error: error()))
        }
    }

}

private extension LogLevel {

    var vqLogLevel: VQLogLevel {
        switch self {
        case .error: return .error
        case .warning: return .warning
        case .info: return .info
        case .debug: return .debug
        case .trace: return .trace
//        @unknown default: return .trace
        }
    }

}
#endif
