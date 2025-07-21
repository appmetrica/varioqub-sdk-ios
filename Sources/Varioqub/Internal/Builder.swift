import Foundation

#if VQ_MODULES
import VarioqubNetwork
import VarioqubUtils
#endif

final class Builder {

    let clientId: String
    let config: VarioqubConfig
    let idProvider: VarioqubIdProvider?
    let reporter: VarioqubReporter?
    let needMigration: Bool
    
    init(
        clientId: String,
        config: VarioqubConfig,
        idProvider: VarioqubIdProvider?,
        reporter: VarioqubReporter?,
        needMigration: Bool
    ) {
        self.clientId = clientId
        self.config = config
        self.idProvider = idProvider
        self.reporter = reporter
        self.needMigration = needMigration
    }
    
    private lazy var defaultSettings: UserDefaultsSettings = createDefaultSettings()
    private lazy var settings: VarioqubSettingsProtocol = createSettings()
    private lazy var migration: SettingsMigrator? = createMigration()
    private lazy var loadables: [VariqubLoadable] = createLoadables()
    private lazy var environment = IOSEnvironment()
    private lazy var varioqubQueue = createQueue()

    func build() -> Container {
        let finalIdProvider = idProvider ?? NullIdProvider()
        
        let idProviderName = finalIdProvider.varioqubName
        let reporterName = reporter?.varioqubName ?? varioqubNullReporterName

        let cfg = InternalConfig(
                baseURL: config.baseURL ?? Configuration.baseURL,
                clientId: clientId,
                fetchThrottle: config.fetchThrottle ?? Configuration.defaultFetchThrottleTime,
                idProviderName: idProviderName,
                repoterName: reporterName
        )
        let networkClient = config.network ?? USNetworkRequestCreator(
                config: .varioqubDefault,
                queue: varioqubQueue
        )

        let factory = MainFactory(
                config: cfg,
                settings: settings,
                networkClient: networkClient,
                idProvider: finalIdProvider,
                reporter: reporter,
                environmentProvider: environment,
                clientFeatures: config.initialClientFeatures,
                queue: varioqubQueue,
                loadables: loadables
        )
        let impl = VarioqubInternalImpl(mainFactory: factory)

        let defaultsWrapper = VarioqubDefaultsAsyncProxy(
            executor: varioqubQueue,
            outputExecutor: config.outputQueue,
            underlyingDefaults: impl
        )
        
        let fetchWrapper = VarioqubFetchAsyncProxy(
                executor: varioqubQueue,
                outputExecutor: config.outputQueue,
                underlyingFetcher: impl
        )

        let initizerWrapper = VarioqubInitializerProxy(
            executor: varioqubQueue,
            underlyingInitiazer: factory.initializer
        )
        let identifiersWrapper = VarioqubIdentifiersProxyProvider(
            executor: varioqubQueue,
            underlyingProvider: factory.identifiersProvider
        )
        let optsWrapper = InternalOptionProxy(
            executor: varioqubQueue,
            underlyingOptions: factory.runtimeOptions
        )

        let container = Container(
                defaultsWrapper: defaultsWrapper,
                fetchWrapper: fetchWrapper,
                flagProvider: factory.flagProvider,
                initializer: initizerWrapper,
                identifiersProvider: identifiersWrapper,
                internalOptions: optsWrapper
        )

        return container
    }
    
    
    private func createLoadables() -> [VariqubLoadable] {
        var result: [VariqubLoadable] = []
        if let migration = migration {
            result.append(migration)
        }
        return result
    }
    
    private func createMigration() -> SettingsMigrator? {
        // support only default settings storage
        if needMigration, config.settingsFactory == nil {
            let oldSettings = UserDefaultsSettingsV0(userDefaults: UserDefaults.standard)
            let migration = SettingsMigrator(input: oldSettings, output: defaultSettings)
            return migration
        } else {
            return nil
        }
    }
    
    private func createDefaultSettings() -> UserDefaultsSettings {
        return UserDefaultsSettings(
            userDefaults: UserDefaults.standard,
            clientId: clientId,
            currentVersion: varioqubVersion
        )
    }
    
    private func createSettings() -> VarioqubSettingsProtocol {
        return self.config.settingsFactory?.createSettings(for: clientId) ?? self.defaultSettings
    }
    
    private func createQueue() -> DispatchQueue {
        return config.varioqubQueue ?? DispatchQueue(label: "Varioqub-\(clientId)")
    }

}
