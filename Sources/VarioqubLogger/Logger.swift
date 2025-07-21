public final class Logger {

    let moduleName: LoggerModule

    public init(moduleName: LoggerModule) {
        self.moduleName = moduleName
        self.destination = LoggerFactory._bootstrap(moduleName)
    }

    public let destination: LoggerDestination

    public func error(_ error: @autoclosure () -> Error) {
        destination.log(module: moduleName, level: .error, error: error())
    }

    public func error(_ msg: @autoclosure () -> String) {
        destination.log(module: moduleName, level: .error, message: msg())
    }

    public func warning(_ error: @autoclosure () -> Error) {
        destination.log(module: moduleName, level: .warning, error: error())
    }

    public func warning(_ msg: @autoclosure () -> String) {
        destination.log(module: moduleName, level: .warning, message: msg())
    }

    public func info(_ msg: @autoclosure () -> String) {
        destination.log(module: moduleName, level: .info, message: msg())
    }

    public func trace(_ msg: @autoclosure () -> String) {
        destination.log(module: moduleName, level: .trace, message: msg())
    }

    public func debug(_ msg: @autoclosure () -> String) {
        destination.log(module: moduleName, level: .debug, message: msg())
    }

}
