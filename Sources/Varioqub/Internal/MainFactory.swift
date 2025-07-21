import Foundation
#if VQ_MODULES
import VarioqubNetwork
import VarioqubUtils
#endif

protocol MainFactoryProtocol: AnyObject {
    var configFetcher: ConfigFetchable { get }
    var flagControllable: ConfigUpdaterControllable { get }
    var flagUpdater: ConfigUpdaterInput { get }
    var threadChecker: ThreadChecker { get }
}

final class MainFactory {

    private let idProvider: VarioqubIdProvider
    private let reporter: VarioqubReporterWrapper

    private let config: InternalConfig
    private let workQueue: DispatchQueue

    private var networkClient: NetworkRequestCreator
    private let _configUpdater: ConfigUpdater

    private let settings: VarioqubSettingsProtocol
    private let settingsProxy: VarioqubSettingsProxy

    private let environmentProvider: EnvironmentProvider

    private let _flagResolver: FlagResolver

    var identifiersProvider: VarioqubIdentifiersProvider { _configUpdater }
    var flagControllable: ConfigUpdaterControllable { _configUpdater }
    var flagProvider: FlagProvider { _flagResolver }

    let initializer: VarioqubInitializable

    let threadChecker: ThreadChecker
    
    let runtimeOptions: RuntimeOptionsStorage

    private(set) lazy var configFetcher: ConfigFetchable = ConfigFetcher(networkClient: networkClient,
            idProvider: idProvider,
            config: config,
            settings: settingsProxy,
            identifiersProvider: _configUpdater,
            executor: workQueue,
            output: _configUpdater,
            environmentProvider: environmentProvider,
            runtimeOptions: runtimeOptions,
            threadChecker: threadChecker
    )

    init(config: InternalConfig, 
         settings: VarioqubSettingsProtocol,
         networkClient: NetworkRequestCreator,
         idProvider: VarioqubIdProvider, 
         reporter: VarioqubReporter?,
         environmentProvider: EnvironmentProvider, 
         clientFeatures: ClientFeatures,
         queue: DispatchQueue,
         loadables: [VariqubLoadable]
    ) {

        self.workQueue = queue
        self.threadChecker = ThreadChecker(queue: queue)
        self.networkClient = networkClient
        self.config = config
        self.settings = settings
        self.idProvider = idProvider
        self.environmentProvider = environmentProvider
        self.settingsProxy = VarioqubSettingsProxy(realSettings: settings)
        self.runtimeOptions = RuntimeOptionsStorage(
            clientFeatures: clientFeatures,
            threadChecker: threadChecker
        )
        self.reporter = VarioqubReporterWrapper(
            storage: settingsProxy,
            underlyingReporter: reporter,
            runtimeOptions: runtimeOptions,
            threadChecker: ThreadChecker(queue: queue)
        )

        self._flagResolver = FlagResolver(output: self.reporter, executor: queue)
        self._configUpdater = ConfigUpdater(output: _flagResolver,
                reporter: self.reporter,
                persistentStorage: settingsProxy,
                threadChecker: threadChecker
        )
        initializer = VarioqubInitializer(items: [self._configUpdater, self.reporter] + loadables)
    }

}

extension MainFactory: MainFactoryProtocol {

    var flagUpdater: ConfigUpdaterInput {
        _configUpdater
    }

}
