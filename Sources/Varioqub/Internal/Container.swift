
struct Container {
    var defaultsWrapper: VarioqubDefaultsSetupable
    var fetchWrapper: VarioqubConfigurable
    var flagProvider: VarioqubFlagProvider
    var initializer: VarioqubInitializable
    var identifiersProvider: VarioqubIdentifiersProvider
    var runtimeOptions: VarioqubRuntimeOptionable
    var resourcesProvider: VarioqubResourcesProvider
    var deeplinkInput: VarioqubDeeplinkInput
}

extension Container {
    
    static let null = Container(
        defaultsWrapper: NullVarioqubDefaultsSetupable(),
        fetchWrapper: NullVarioqubConfigurable(),
        flagProvider: NullFlagProvider(),
        initializer: NullVarioqubInitializable(),
        identifiersProvider: NullVarioqubIdentifiersProvider(),
        runtimeOptions: NullRuntimeOptionable(),
        resourcesProvider: NullResourceProvider(),
        deeplinkInput: NullVarioqubDeeplink()
    )
    
}

