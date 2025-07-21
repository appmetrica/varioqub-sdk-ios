
final class NullFlagProvider: FlagProvider {
    
    var allItems: [VarioqubFlag : VarioqubConfigValue] {
        [:]
    }
    
    var allKeys: Set<VarioqubFlag> {
        Set()
    }

    func get<T>(for flag: VarioqubFlag, type: T.Type, defaultValue: T?) -> T where T: VarioqubInitializableByValue {
        FlagResolverStrategy.selectValue(configValue: nil, userProviderDefaultValue: defaultValue, type: type)
    }

    func getValue(for flag: VarioqubFlag) -> VarioqubConfigValue {
        VarioqubConfigValue(source: .defaultValue, value: nil, triggeredTestID: nil)
    }

}
