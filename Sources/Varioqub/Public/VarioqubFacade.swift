import Foundation
#if VQ_MODULES
import VarioqubNetwork
import VarioqubUtils
#endif
import Dispatch

/// An entry point for Varioqub. Use ``VarioqubFacade/shared`` to access Varioqub.
public final class VarioqubFacade {

    /// A global Varioqub instance.
    public static let shared = VarioqubFacade()

    private var _mainContainer: Container = .null
    private var _mainInstance: VarioqubInstance = .null
    
    private var extendedInstances: UnfairDictionary<String, VarioqubInstance> = [:]
    
    private init() {
    }

}

extension VarioqubFacade {

    /// Initialize main Varioqub instance. Must be called in the first place.
    ///
    /// Use this method to activate main Varioqub instance. This is also setup migration from Varioqub 0.7.0 to newer versions if ``VarioqubConfig/settingsFactory`` is not set.
    ///
    /// Use ``VarioqubFacade/mainInstance`` or ``VarioqubFacade/instance(clientId:)`` to access to instance
    ///
    /// - returns: main instance
    /// - parameter clientId: A string in the following format: "appmetrica.\\(appId)". You can take the appId from https://appmetrica.io.
    /// - parameter config: The Varioqub configuration. After initialization, you can't change it.
    /// - parameter idProvider: Optional, if you want to use AppMetrica identifiers. Currently available only for MetricaAdapter and MetricaAdapterReflection.
    /// - parameter reporter: Optional, if you want to use analytics. Currently available only for MetricaAdapter and MetricaAdapterReflection.
    @discardableResult
    public func initialize(
        clientId: String,
        config: VarioqubConfig = .default,
        idProvider: VarioqubIdProvider?,
        reporter: VarioqubReporter?
    ) -> VarioqubInstance {
        
        let instance = extendedInstances.getOrPut(key: clientId) {
            let builder = Builder(
                clientId: clientId,
                config: config,
                idProvider: idProvider,
                reporter: reporter,
                needMigration: true
            )
            let container = builder.build()
            container.initializer.start()
            return VarioqubInstance(container: container)
        }
        
        self._mainInstance = instance
        self._mainContainer = instance.container
        
        return instance
    }
    
    /// main Varioqub instance or null instance if it isn't activated
    ///
    ///
    /// ``VarioqubFacade/initialize(clientId:config:idProvider:reporter:)`` must be called before using this property. Also it can be accessible by ``VarioqubFacade/instance(clientId:)``.
    ///
    public var mainInstance: VarioqubInstance {
        return _mainInstance
    }
    
    /// Initialize varioqub instance.
    ///
    /// This is can called many times and create new instance for each client id. Calling twice with same clientId return existing instance.
    /// - returns: instance for clientId
    /// - parameter clientId: A string in the following format: "appmetrica.\\(appId)". You can take the appId from https://appmetrica.io/.
    /// - parameter config: The Varioqub configuration. After initialization, you can't change it.
    /// - parameter idProvider: Optional, if you want to use AppMetrica identifiers. Currently available only for MetricaAdapter and MetricaAdapterReflection.
    /// - parameter reporter: Optional, if you want to use analytics. Currently available only for MetricaAdapter and MetricaAdapterReflection.

    @discardableResult
    public func initializeInstance(clientId: String, config: VarioqubConfig = .default, idProvider: VarioqubIdProvider?, reporter: VarioqubReporter?) -> VarioqubInstance {
        let instance = extendedInstances.getOrPut(key: clientId) {
            let builder = Builder(
                clientId: clientId,
                config: config,
                idProvider: idProvider,
                reporter: reporter,
                needMigration: false
            )
            let container = builder.build()
            container.initializer.start()
            return VarioqubInstance(container: container)
        }
        
        return instance
    }
    
    /// Return Varioqub Instance
    ///
    /// return previously initializated instance or null instance.
    /// Call ``VarioqubFacade/initializeInstance(clientId:config:idProvider:reporter:)`` before using this method
    public func instance(clientId: String) -> VarioqubInstance {
        return extendedInstances[clientId] ?? .null
    }

}

extension VarioqubFacade: VarioqubRuntimeOptionable {

    /// An additional key-value set to send to Varioqub server.
    ///
    /// No operation is performed before ``VarioqubFacade/initialize(clientId:config:idProvider:reporter:)`` is called.
    public var clientFeatures: VarioqubClientFeatures {
        get { return _mainContainer.runtimeOptions.clientFeatures }
        set { _mainContainer.runtimeOptions.clientFeatures = newValue }
    }

    /// Enables or disables sending event when a new config is activated.
    ///
    /// You should provide the ``VarioqubFacade/initialize(clientId:config:idProvider:reporter:)`` reporter and implement ``VarioqubReporter/sendActivateEvent(_:)`` (for example, using ``VarioqubAppMetricaAdapter.AppMetricaAdapter``).
    ///
    /// See also ``VarioqubFacade/activateConfigAndWait()`` and ``VarioqubFacade/activateConfig(_:)``.
    public var sendEventOnChangeConfig: Bool {
        get { return _mainContainer.runtimeOptions.sendEventOnChangeConfig }
        set { _mainContainer.runtimeOptions.sendEventOnChangeConfig = newValue }
    }
    
    public var runtimeParams: VarioqubParameters {
        get { return _mainContainer.runtimeOptions.runtimeParams }
        set { _mainContainer.runtimeOptions.runtimeParams = newValue }
    }

}

extension VarioqubFacade {

    /// Varioqub identifier.
    ///
    /// An identifier that allows setting up the experiment for a specific device only. See [Varioqub SDK integration documentation](https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#get-id) for more information.
    /// It returns nil before ``VarioqubFacade/fetchConfig(_:)`` is completed.
    public var varioqubId: String? {
        return _mainContainer.identifiersProvider.varioqubIdentifier
    }

}

extension VarioqubFacade: VarioqubConfigurable {

    /// Fetches a new config and stores it.
    ///
    /// This method doesn't apply the config, see ``VarioqubFacade/activateConfig(_:)`` and ``VarioqubFacade/activateConfigAndWait()`` for that.
    ///
    /// - parameter callback: Called when fetching is completed.
    public func fetchConfig(_ callback: FetchCallback?) {
        varioqubLogger.trace("fetchConfig")
        _mainContainer.fetchWrapper.fetchConfig(callback)
    }

    /// Activates a config and notifies via a callback when it completes.
    ///
    /// This method doesn't block the callee.
    ///
    /// See also: ``VarioqubFacade/activateConfigAndWait()(_:)``.
    ///
    /// - parameter callback: called when activating is completed
    public func activateConfig(_ callback: ActivateCallback?) {
        varioqubLogger.trace("activateConfig")
        _mainContainer.fetchWrapper.activateConfig(callback)
    }

    /// Activates a config.
    ///
    /// This method waits for the config application.
    ///
    /// See also: ``VarioqubFacade/activateConfig(_:)``.
    public func activateConfigAndWait() {
        varioqubLogger.trace("activateConfigAndWait")
        _mainContainer.fetchWrapper.activateConfigAndWait()
    }

    /// Fetches a new config and activates it.
    ///
    /// Activating a new config isn't performed when fetching it fails.
    /// If the fetch status is `` ConfigFetcherAnswer.success``, ``ConfigFetcherAnswer.throttled``, or ``ConfigFetcherAnswer.cached``, it activates a new config.
    /// - parameter callback: Notifies when fetching and activating is finished.
    public func fetchAndActivateConfig(_ callback: FetchCallback?) {
        varioqubLogger.trace("fetchAndActivateConfig")
        _mainContainer.fetchWrapper.fetchAndActivateConfig(callback)
    }

}

extension VarioqubFacade: VarioqubDefaultsSetupable {

    /// Adds key-value pairs into the config.
    ///
    /// The server config has higher priority over these values.
    ///
    /// Method doesn't block callee and notifies about finishing via callback.
    ///
    /// See also: ``VarioqubFacade/setDefaultsAndWait(_:)``.
    /// - parameter defaults: The dictionary with flags and values.
    /// - parameter callback: Notifies when setting is completed.
    public func setDefaults(_ defaults: [VarioqubFlag: String], callback: DefaultsCallback?) {
        varioqubLogger.trace("setDefaults \(defaults)")
        _mainContainer.defaultsWrapper.setDefaults(defaults, callback: callback)
    }

    /// Loads key-value pairs from an XML.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(at:)``.
    ///
    /// - parameter path: The path to the XML file.
    /// - parameter callback: Notifies about finishing.
    public func loadXml(at path: URL, callback: XmlParserCallback?) {
        varioqubLogger.trace("loadXml \(path)")
        _mainContainer.defaultsWrapper.loadXml(at: path, callback: callback)
    }

    /// Loads key-value pairs from XML-encoded data.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(from:)``.
    ///
    /// - parameter data: The data that represents XML.
    /// - parameter callback: Notifies about finishing.
    public func loadXml(from data: Data, callback: XmlParserCallback?) {
        varioqubLogger.trace("loadXml \(data.base64EncodedString())")
        _mainContainer.defaultsWrapper.loadXml(from: data, callback: callback)
    }

    /// Adds key-value pairs into config.
    ///
    /// The server config has higher priority over these values.
    ///
    /// See also: ``VarioqubFacade/setDefaults(_:callback:)``.
    /// - parameter defaults: The dictionary with flags and values.
    public func setDefaultsAndWait(_ defaults: [VarioqubFlag: String]) {
        varioqubLogger.trace("setDefaultsAndWait \(defaults)")
        _mainContainer.defaultsWrapper.setDefaultsAndWait(defaults)
    }

    /// Loads key-value pairs from an XML.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(at:)``.
    ///
    /// - parameter path: The path to the XML file.
    public func loadXmlAndWait(at path: URL) throws {
        varioqubLogger.trace("loadXmlAndWait \(path)")
        try _mainContainer.defaultsWrapper.loadXmlAndWait(at: path)
    }

    /// Loads key-value pairs from XML-encoded data.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(at:)``.
    ///
    /// - parameter from: The data that represents XML.
    public func loadXmlAndWait(from data: Data) throws {
        varioqubLogger.trace("loadXmlAndWait \(data.base64EncodedString())")
        try _mainContainer.defaultsWrapper.loadXmlAndWait(from: data)
    }

}

extension VarioqubFacade: VarioqubResourcesProvider {
    
    public func resource(for key: VarioqubResourceKey) -> VarioqubResource? {
        return _mainContainer.resourcesProvider.resource(for: key)
    }
    
}

extension VarioqubFacade: VarioqubDeeplinkInput {
    
    public func handleDeeplink(_ url: URL) -> Bool {
        fatalError()
    }
    
}

extension VarioqubFacade: VarioqubFlagProvider {

    /// All active flags.
    public var allItems: [VarioqubFlag : VarioqubConfigValue] {
        return _mainContainer.flagProvider.allItems
    }

    /// All active keys.
    public var allKeys: Set<VarioqubFlag> {
        return _mainContainer.flagProvider.allKeys
    }

    /// Gets the value for the flag.
    ///
    /// - parameter flag: The flag.
    /// - parameter type: Returns T.
    /// - parameter defaultValue: The value that will be returned if nothing could be found.
    /// - returns: The value in the active config.
    public func get<T>(for flag: VarioqubFlag, type: T.Type, defaultValue: T?) -> T where T: VarioqubInitializableByValue {
        return _mainContainer.flagProvider.get(for: flag, type: type, defaultValue: defaultValue)
    }

    /// Gets the raw value that can be convert to a specific type.
    ///
    /// - parameter flag: The flag.
    /// - returns: The value in the active config or an empty value if nothing could be found.
    public func getValue(for flag: VarioqubFlag) -> VarioqubConfigValue {
        return _mainContainer.flagProvider.getValue(for: flag)
    }

}

