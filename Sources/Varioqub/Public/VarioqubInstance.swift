
import Foundation

/// VarioqubInstance represents varioqub with custom cliend id.
///
/// The main goal of VarioqubInstance is to provide access to Varioqub for multiple libraries without affecting the application.
/// See ``VarioqubFacade/initializeInstance(clientId:config:idProvider:reporter:)`` and ``VarioqubFacade/instance(clientId:)``
public final class VarioqubInstance {
    let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    public static let null = VarioqubInstance(container: .null)
    
}

extension VarioqubInstance: VarioqubRuntimeOptionable {

    /// An additional key-value set to send to Varioqub server.
    ///
    /// No operation is performed before ``VarioqubFacade/initialize(clientId:config:idProvider:reporter:)`` is called.
    public var clientFeatures: ClientFeatures {
        get { return container.runtimeOptions.clientFeatures }
        set { container.runtimeOptions.clientFeatures = newValue }
    }

    /// Enables or disables sending event when a new config is activated.
    ///
    /// You should provide the ``VarioqubFacade/initialize(clientId:config:idProvider:reporter:)`` reporter and implement ``VarioqubReporter/sendActivateEvent(_:)`` (for example, using ``VarioqubAppMetricaAdapter.AppMetricaAdapter``).
    ///
    /// See also ``VarioqubFacade/activateConfigAndWait()`` and ``VarioqubFacade/activateConfig(_:)``.
    public var sendEventOnChangeConfig: Bool {
        get { return container.runtimeOptions.sendEventOnChangeConfig }
        set { container.runtimeOptions.sendEventOnChangeConfig = newValue }
    }
    
    public var runtimeParams: VarioqubParameters {
        get { return container.runtimeOptions.runtimeParams }
        set { container.runtimeOptions.runtimeParams = newValue }
    }

}

extension VarioqubInstance {

    /// Varioqub identifier.
    ///
    /// An identifier that allows setting up the experiment for a specific device only. See [Varioqub SDK integration documentation](https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#get-id) for more information.
    /// It returns nil before ``VarioqubFacade/fetchConfig(_:)`` is completed.
    public var varioqubId: String? {
        return container.identifiersProvider.varioqubIdentifier
    }

}

extension VarioqubInstance: VarioqubConfigurable {

    /// Fetches a new config and stores it.
    ///
    /// This method doesn't apply the config, see ``VarioqubFacade/activateConfig(_:)`` and ``VarioqubFacade/activateConfigAndWait()`` for that.
    ///
    /// - parameter callback: Called when fetching is completed.
    public func fetchConfig(_ callback: FetchCallback?) {
        varioqubLogger.trace("fetchConfig")
        container.fetchWrapper.fetchConfig(callback)
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
        container.fetchWrapper.activateConfig(callback)
    }

    /// Activates a config.
    ///
    /// This method waits for the config application.
    ///
    /// See also: ``VarioqubFacade/activateConfig(_:)``.
    public func activateConfigAndWait() {
        varioqubLogger.trace("activateConfigAndWait")
        container.fetchWrapper.activateConfigAndWait()
    }

    /// Fetches a new config and activates it.
    ///
    /// Activating a new config isn't performed when fetching it fails.
    /// If the fetch status is `` ConfigFetcherAnswer.success``, ``ConfigFetcherAnswer.throttled``, or ``ConfigFetcherAnswer.cached``, it activates a new config.
    /// - parameter callback: Notifies when fetching and activating is finished.
    public func fetchAndActivateConfig(_ callback: FetchCallback?) {
        varioqubLogger.trace("fetchAndActivateConfig")
        container.fetchWrapper.fetchAndActivateConfig(callback)
    }

}

extension VarioqubInstance: VarioqubDefaultsSetupable {

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
        container.defaultsWrapper.setDefaults(defaults, callback: callback)
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
        container.defaultsWrapper.loadXml(at: path, callback: callback)
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
        container.defaultsWrapper.loadXml(from: data, callback: callback)
    }

    /// Adds key-value pairs into config.
    ///
    /// The server config has higher priority over these values.
    ///
    /// See also: ``VarioqubFacade/setDefaults(_:callback:)``.
    /// - parameter defaults: The dictionary with flags and values.
    public func setDefaultsAndWait(_ defaults: [VarioqubFlag: String]) {
        varioqubLogger.trace("setDefaultsAndWait \(defaults)")
        container.defaultsWrapper.setDefaultsAndWait(defaults)
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
        try container.defaultsWrapper.loadXmlAndWait(at: path)
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
        try container.defaultsWrapper.loadXmlAndWait(from: data)
    }

}

extension VarioqubInstance: VarioqubResourcesProvider {
    
    public func resource(for key: VarioqubResourceKey) -> VarioqubResource? {
        return container.resourcesProvider.resource(for: key)
    }
    
}

extension VarioqubInstance: VarioqubDeeplinkInput {
    
    public func handleDeeplink(_ url: URL) -> Bool {
        container.deeplinkInput.handleDeeplink(url)
    }
    
}

extension VarioqubInstance: VarioqubFlagProvider {

    /// All active flags.
    public var allItems: [VarioqubFlag : VarioqubConfigValue] {
        return container.flagProvider.allItems
    }

    /// All active keys.
    public var allKeys: Set<VarioqubFlag> {
        return container.flagProvider.allKeys
    }

    /// Gets the value for the flag.
    ///
    /// - parameter flag: The flag.
    /// - parameter type: Returns T.
    /// - parameter defaultValue: The value that will be returned if nothing could be found.
    /// - returns: The value in the active config.
    public func get<T>(for flag: VarioqubFlag, type: T.Type, defaultValue: T?) -> T where T: VarioqubInitializableByValue {
        return container.flagProvider.get(for: flag, type: type, defaultValue: defaultValue)
    }

    /// Gets the raw value that can be convert to a specific type.
    ///
    /// - parameter flag: The flag.
    /// - returns: The value in the active config or an empty value if nothing could be found.
    public func getValue(for flag: VarioqubFlag) -> VarioqubConfigValue {
        return container.flagProvider.getValue(for: flag)
    }

}

