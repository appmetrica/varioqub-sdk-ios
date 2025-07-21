import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
extension VQVarioqubInstance {
    
    var allItems: [VQFlag: VQConfigValue] {
        var result: [VQFlag: VQConfigValue] = [:]
        originalInstance.allItems.forEach { (k, v) in
            result[k.rawValue] = VQConfigValue(configValue: v)
        }
        return result
    }
    
    var allKeys: Set<VQFlag> {
        Set(originalInstance.allKeys.map { $0.rawValue })
    }

    func getValue(for flag: VQFlag) -> VQConfigValue {
        VQConfigValue(configValue: originalInstance.getValue(for: .init(rawValue: flag)))
    }

    func getString(for flag: VQFlag, defaultValue: String) -> String {
        originalInstance.getString(for: .init(rawValue: flag), defaultValue: defaultValue)
    }

    func getString(for flag: VQFlag) -> String {
        originalInstance.getString(for: .init(rawValue: flag), defaultValue: nil)
    }

    func getDouble(for flag: VQFlag, defaultValue: Double) -> Double {
        originalInstance.getDouble(for: .init(rawValue: flag), defaultValue: defaultValue)
    }

    func getDouble(for flag: VQFlag) -> Double {
        originalInstance.getDouble(for: .init(rawValue: flag), defaultValue: nil)
    }

    func getLong(for flag: VQFlag, defaultValue: Int64) -> Int64 {
        originalInstance.getInt64(for: .init(rawValue: flag), defaultValue: defaultValue)
    }

    func getLong(for flag: VQFlag) -> Int64 {
        originalInstance.getInt64(for: .init(rawValue: flag), defaultValue: nil)
    }

    func getInt(for flag: VQFlag) -> Int {
        originalInstance.getInt(for: .init(rawValue: flag), defaultValue: nil)
    }

    func getBool(for flag: VQFlag, defaultValue: Bool) -> Bool {
        let dv = defaultValue
        return originalInstance.getBool(for: .init(rawValue: flag), defaultValue: dv)
    }

    func getBool(for flag: VQFlag) -> Bool {
        originalInstance.getBool(for: .init(rawValue: flag), defaultValue: nil)
    }
}
