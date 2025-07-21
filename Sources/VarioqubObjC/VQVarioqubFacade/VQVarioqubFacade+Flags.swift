
import Foundation

#if VQ_MODULES
import Varioqub
#endif



@objc
public extension VQVarioqubFacade {
    
    var allItems: [VQFlag: VQConfigValue] {
        mainInstance.allItems
    }
    
    var allKeys: Set<VQFlag> {
        mainInstance.allKeys
    }

    func getValue(for flag: VQFlag) -> VQConfigValue {
        mainInstance.getValue(for: flag)
    }

    func getString(for flag: VQFlag, defaultValue: String) -> String {
        mainInstance.getString(for: flag, defaultValue: defaultValue)
    }

    func getString(for flag: VQFlag) -> String {
        mainInstance.getString(for: flag)
    }

    func getDouble(for flag: VQFlag, defaultValue: Double) -> Double {
        mainInstance.getDouble(for: flag, defaultValue: defaultValue)
    }

    func getDouble(for flag: VQFlag) -> Double {
        mainInstance.getDouble(for: flag)
    }

    func getLong(for flag: VQFlag, defaultValue: Int64) -> Int64 {
        mainInstance.getLong(for: flag, defaultValue: defaultValue)
    }

    func getLong(for flag: VQFlag) -> Int64 {
        mainInstance.getLong(for: flag)
    }

    func getInt(for flag: VQFlag) -> Int {
        mainInstance.getInt(for: flag)
    }

    func getBool(for flag: VQFlag, defaultValue: Bool) -> Bool {
        mainInstance.getBool(for: flag, defaultValue: defaultValue)
    }

    func getBool(for flag: VQFlag) -> Bool {
        mainInstance.getBool(for: flag)
    }

}
