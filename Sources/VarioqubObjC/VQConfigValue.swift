
import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public enum VQSource: Int {
    case defaultValue
    case inappConfig
    case server
}

@objc
public final class VQConfigValue: NSObject {

    let configValue: VarioqubConfigValue

    public init(configValue: VarioqubConfigValue) {
        self.configValue = configValue
        super.init()
    }

    @objc
    public var source: VQSource {
        switch configValue.source {
        case .defaultValue: return .defaultValue
        case .inappDefault: return .inappConfig
        case .server: return .server
        }
    }

    @objc
    public var testID: VQTestID {
        configValue.triggeredTestID?.rawValue ?? 0
    }

    @objc
    public var value: String? {
        configValue.value?.rawValue
    }

    @objc
    public var numberValue: NSNumber? {
        if let intValue = configValue.int64Value {
            return NSNumber(value: intValue)
        } else if let doubleValue = configValue.doubleValue {
            return NSNumber(value: doubleValue)
        } else if let boolValue = configValue.boolValue {
            return NSNumber(value: boolValue)
        } else {
            return nil
        }
    }

    @objc
    public var stringValueOrDefault: String? {
        configValue.stringValueOrDefault
    }

    @objc
    public var intValueOrDefault: Int {
        configValue.intValueOrDefault
    }

    @objc
    public var int64ValueOrDefault: Int {
        configValue.intValueOrDefault
    }

    @objc
    public var boolValueOrDefault: Bool {
        configValue.boolValueOrDefault
    }

}
