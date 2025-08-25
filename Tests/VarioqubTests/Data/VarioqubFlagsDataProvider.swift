
@testable import Varioqub

enum VarioqubFlagsDataProvider {
    
    static func simpleResources() -> [VarioqubResourceKey: VarioqubResource] {
        return [
            VarioqubResourceKey(rawValue: "key1"): VarioqubResource(type: "string", value: "value1"),
            VarioqubResourceKey(rawValue: "key2"): VarioqubResource(type: "string", value: "value2"),
            VarioqubResourceKey(rawValue: "key3"): VarioqubResource(type: "string", value: "value3"),
        ]
    }
    
    static func param1Flags() -> [VarioqubFlag: VarioqubConfigValue] {
        return [
            VarioqubFlag("flag4"): VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: "test123"),
                triggeredTestID: 123
            )
        ]
    }
    
    static func param2Flags() -> [VarioqubFlag: VarioqubConfigValue] {
        return [
            VarioqubFlag("flag4"): VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: "test234"),
                triggeredTestID: 234
            )
        ]
    }
    
    static func defaultValues() -> [VarioqubFlag: VarioqubConfigValue] {
        return [
            VarioqubFlag(rawValue: "flag0"): VarioqubConfigValue(
                source: .inappDefault,
                value: VarioqubValue(string: "999"),
                triggeredTestID: nil
            ),
            VarioqubFlag(rawValue: "flag1"): VarioqubConfigValue(
                source: .inappDefault,
                value: VarioqubValue(string: "888"),
                triggeredTestID: nil
            ),
        ]
    }
    
    static func deeplink1Flags() -> [VarioqubFlag: VarioqubConfigValue] {
        return [
            VarioqubFlag("flag5"): VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: "test456"),
                triggeredTestID: 456
            )
        ]
    }
    
    static func deeplink2Flags() -> [VarioqubFlag: VarioqubConfigValue] {
        return [
            VarioqubFlag("flag5"): VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: "test567"),
                triggeredTestID: 567
            )
        ]
    }
    
    static func simpleFlags() -> [VarioqubFlag: VarioqubConfigValue] {
        return [
            VarioqubFlag(rawValue: "flag1"): VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: "test234"),
                triggeredTestID: VarioqubTestID(rawValue: 234)
            ),
            VarioqubFlag(rawValue: "flag2"): VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: "234"),
                triggeredTestID: VarioqubTestID(rawValue: 34)
            ),
            VarioqubFlag(rawValue: "flag3"): VarioqubConfigValue(
                source: .server,
                value: VarioqubValue(string: "false"),
                triggeredTestID: VarioqubTestID(rawValue: 23)
            ),
        ]
    }
    
    static func simpleWithDefaultFlags() -> [VarioqubFlag: VarioqubConfigValue] {
        let defaultValues = [
            VarioqubFlag(rawValue: "flag0"): VarioqubConfigValue(
                source: .inappDefault,
                value: VarioqubValue(string: "999"),
                triggeredTestID: nil
            )
        ]
        
        return simpleFlags().merging(defaultValues, uniquingKeysWith: { $1 })
    }
    
    static func simpleWithAll() -> [VarioqubFlag: VarioqubConfigValue] {
        return simpleWithDefaultFlags()
            .merging(param2Flags(), uniquingKeysWith: { $1 })
            .merging(deeplink2Flags(), uniquingKeysWith: { $1 })
    }
    
}
