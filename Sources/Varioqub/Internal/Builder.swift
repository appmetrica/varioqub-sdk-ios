import Foundation

#if VQ_MODULES
import VarioqubNetwork
import VarioqubUtils
#endif

private struct Input {
    var idProvider: VarioqubIdProvider
    var idProviderName: String
    var reporterName: String
    var cfg: InternalConfig
    var networkClient: NetworkRequestCreator
}

final class Builder {

    let clientId: String
    let config: VarioqubConfig
    let idProvider: VarioqubIdProvider
    let reporter: VarioqubReporter?
    let needMigration: Bool
    
    let idProviderName: String
    let reporterName: String
    
    init(
        clientId: String,
        config: VarioqubConfig,
        idProvider: VarioqubIdProvider?,
        reporter: VarioqubReporter?,
        needMigration: Bool
    ) {
        self.clientId = clientId
        self.config = config
        self.idProvider = idProvider ?? NullIdProvider()
        self.reporter = reporter
        self.needMigration = needMigration
        
        self.idProviderName = self.idProvider.varioqubName
        self.reporterName = reporter?.varioqubName ?? varioqubNullReporterName
    }
    
    private lazy var internalConfig = InternalConfig(
        baseURL: config.baseURL ?? Configuration.baseURL,
        clientId: clientId,
        fetchThrottle: config.fetchThrottle ?? Configuration.defaultFetchThrottleTime,
        idProviderName: idProviderName,
        repoterName: reporterName
    )
    private lazy var threadChecker = ThreadChecker(queue: config.varioqubQueue)
    private lazy var networkClient: NetworkRequestCreator = createNetworkClient()
    private lazy var defaultSettings: UserDefaultsSettings = createDefaultSettings()
    private lazy var settings: VarioqubSettingsProtocol = createSettings()
    private lazy var migration: SettingsMigrator? = createMigration()
    private lazy var loadables: [VariqubLoadable] = createLoadables()
    private lazy var environment = IOSEnvironment()
    private lazy var varioqubQueue = createQueue()
    private lazy var slotHolder = createSlotHolder()
    private lazy var settingsProxy = createSettingsProxy()
    private lazy var runtimeOptions = createRuntimeOptions()
    private lazy var reporterWrapper = createReporterWrapper()
    private lazy var flagResolver = createFlagResolver()
    private lazy var configFetcher = createConfigFetcher()
    private lazy var impl = createImpl()
    private lazy var initializer = createInitializer()
    private lazy var flagController = createFlagController()
    

    func build() -> Container {
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

        let initizerWrapper = VarioqubInitializerAsyncProxy(
            executor: varioqubQueue,
            underlyingInitiazer: initializer
        )
        let identifiersWrapper = VarioqubIdentifiersProxyProvider(
            executor: varioqubQueue,
            underlyingProvider: slotHolder
        )
        let optsWrapper = VarioqubRuntimeOptionAsyncProxy(
            executor: varioqubQueue,
            underlyingOptions: impl
        )
        let deeplinkInput = VarioqubDeeplinkInputAsyncProxy(
            executor: varioqubQueue,
            underlyingDeepLinkInput: impl
        )

        let container = Container(
                defaultsWrapper: defaultsWrapper,
                fetchWrapper: fetchWrapper,
                flagProvider: flagResolver,
                initializer: initizerWrapper,
                identifiersProvider: identifiersWrapper,
                runtimeOptions: optsWrapper,
                resourcesProvider: flagResolver,
                deeplinkInput: deeplinkInput
        )

        return container
    }
    
    private func createRuntimeOptions() -> RuntimeOptionsHolder {
        return RuntimeOptionsHolder(
            clientFeatures: config.initialClientFeatures,
            threadChecker: threadChecker
        )
    }
    
    private func createNetworkClient() -> NetworkRequestCreator {
        return config.network ?? USNetworkRequestCreator(
                config: .varioqubDefault,
                queue: varioqubQueue
        )
    }
    
    private func createLoadables() -> [VariqubLoadable] {
        var result: [VariqubLoadable] = [
            slotHolder,
            reporterWrapper,
        ]
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
    
    private func createSlotHolder() -> SlotHolder {
        return SlotHolder(
            settings: settings,
            output: flagController,
            reporter: reporterWrapper
        )
    }
    
    private func createSettingsProxy() -> VarioqubSettingsProxy {
        return VarioqubSettingsProxy(realSettings: settings)
    }
    
    private func createFlagResolver() -> FlagResolver {
        return FlagResolver(
            output: reporterWrapper,
            executor: varioqubQueue
        )
    }
    
    private func createReporterWrapper() -> VarioqubReporterWrapper {
        return VarioqubReporterWrapper(
            storage: settingsProxy,
            underlyingReporter: reporter,
            runtimeOptions: runtimeOptions,
            threadChecker: threadChecker
        )
    }
    
    private func createConfigFetcher() -> ConfigFetcher {
        return ConfigFetcher(
            networkClient: networkClient,
            idProvider: idProvider,
            config: internalConfig,
            settings: settingsProxy,
            identifiersProvider: slotHolder,
            executor: varioqubQueue,
            output: slotHolder,
            environmentProvider: environment,
            runtimeOptions: runtimeOptions,
            threadChecker: threadChecker
        )
    }
    
    private func createImpl() -> VarioqubInternalImpl {
        return VarioqubInternalImpl(
            configFetcher: configFetcher,
            slotController: slotHolder,
            flagController: flagController,
            runtimeOptions: runtimeOptions,
            threadChecker: threadChecker
        )
    }
    
    private func createInitializer() -> VarioqubInitializer {
        return VarioqubInitializer(items: loadables)
    }
    
    private func createFlagController() -> FlagController {
        return FlagController(output: flagResolver)
    }

}
