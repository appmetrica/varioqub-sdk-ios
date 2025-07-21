enum FlagResolverStrategy {

    static func selectValue<T>(configValue: VarioqubValue?, userProviderDefaultValue: T?, type: T.Type) -> T where T: VarioqubInitializableByValue {
        configValue.flatMap(type.init(value:)) ?? userProviderDefaultValue ?? type.defaultValue
    }

    static func selectOptionalValue<T>(configValue: VarioqubValue?, userProviderDefaultValue: T?, type: T.Type) -> T? where T: VarioqubInitializableByValue {
        configValue.flatMap(type.init(value:)) ?? userProviderDefaultValue
    }

}
