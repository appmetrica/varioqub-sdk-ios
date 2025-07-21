
struct Container {
    var defaultsWrapper: VarioqubDefaultsSetupable
    var fetchWrapper: VarioqubConfigurable
    var flagProvider: FlagProvider
    var initializer: VarioqubInitializable
    var identifiersProvider: VarioqubIdentifiersProvider
    var internalOptions: RuntimeOptionable
}

extension Container {
    
    static let null = Container(
        defaultsWrapper: NullVarioqubDefaultsSetupable(),
        fetchWrapper: NullVarioqubConfigurable(),
        flagProvider: NullFlagProvider(),
        initializer: NullVarioqubInitializable(),
        identifiersProvider: NullVarioqubIdentifiersProvider(),
        internalOptions: NullRuntimeOptionable()
    )
    
}

