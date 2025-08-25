import Foundation

#if VQ_MODULES
import VarioqubNetwork
import VarioqubUtils
#endif

/// The struct that represents identifiers for Varioqub.
public struct VarioqubIdentifiers {

    /// The property for the device identifier.
    public var deviceId: String

    /// The property for the user identifier.
    public var userId: String

    /// Initializes with the device and user identifiers.
    public init(deviceId: String, userId: String) {
        self.deviceId = deviceId
        self.userId = userId
    }

    /// Returns if identifiers are empty.
    @available(*, deprecated, renamed: "isEmpty", message: "use isEmpty as more suitable name")
    public var isValid: Bool {
        isEmpty
    }

    /// Returns if identifiers are a non-empty string.
    public var isEmpty: Bool {
        !deviceId.isEmpty && !userId.isEmpty
    }


    public static let empty = VarioqubIdentifiers(deviceId: "", userId: "")
}

/// The enum that represents Varioqub errors.
public enum VarioqubProviderError: Error {
    /// A general error.
    case general

    /// Informs the client that an error occurred due to an underlying error.
    /// - parameter error: The underlying error.
    case underlying(error: Error)
}

/// The protocol that provides a name.
///
/// This is used in the adapter and reporter for analytics purposes.
/// See details: ``VarioqubIdProvider`` and ``VarioqubReporter``.
public protocol VarioqubNameProvider {
    /// Returns the name of the adapter or reporter.
    var varioqubName: String { get }
}

/// The protocol that provides methods for retrieving client identifiers.
public protocol VarioqubIdProvider: VarioqubNameProvider {
    /// The closure for receiving identifiers.
    typealias Completion = (Result<VarioqubIdentifiers, VarioqubProviderError>) -> ()

    /// Retrieves the device and user identifiers.
    func fetchIdentifiers(completion: @escaping Completion)
}

/// The struct that represents event data after the config was changed.
public struct VarioqubEventData {
    /// The date and time when the config was fetched.
    ///
    /// This property can be nil if you upgrade from Varioqub-0.5.0 or older.
    public var fetchDate: Date?

    /// The old config version.
    public var oldVersion: String?

    /// The new config version.
    public var newVersion: String

    /// Initializes the structure.
    /// - parameter fetchData: The date and time when the new config was fetched.
    /// - parameter oldVersion: The old config version.
    /// - parameter newVersion: The new config version.
    public init(fetchDate: Date? = nil, oldVersion: String? = nil, newVersion: String) {
        self.fetchDate = fetchDate
        self.oldVersion = oldVersion
        self.newVersion = newVersion
    }
}

/// The protocol for reporting config changes.
// sourcery: AutoMockable
public protocol VarioqubReporter: AnyObject, VarioqubNameProvider {
    /// Sets currently active experiments.
    /// - parameter experiments: The currently active experiments.
    func setExperiments(_ experiments: String)

    /// Sets the triggered test IDs.
    /// - parameter triggeredTestIds: The set of the triggered test IDs.
    func setTriggeredTestIds(_ triggeredTestIds: VarioqubTestIDSet)

    /// Reports a configuration change.
    /// - paramter eventData: eventData with the currently active config.
    func sendActivateEvent(_ eventData: VarioqubEventData)
}

/// Configuration for Varioqub.
///
/// This structure contains the configuration for Varioqub. Leave properties as nil to use Varioqub defaults.
public struct VarioqubConfig {
    /// The URL for Varioqub. Used for testing purposes.
    public var baseURL: URL?

    /// Custom settings adapter to store Varioqub data persistently. Migration must be implemented by adapter
    ///
    /// See details: ``VarioqubSettingsFactory``.
    public var settingsFactory: VarioqubSettingsFactory?

    /// A custom network creator.
    ///
    /// Use this option to implement if you want to use custom network stack.
    public var network: NetworkRequestCreator?

    /// Sets an interval for fetch requests. Default is 43200.
    public var fetchThrottle: TimeInterval?

    /// The client features which represent addtional key-value data that you can attach to Varioqub requests used for experiment filtering.
    public var initialClientFeatures: VarioqubClientFeatures = .init()

    /// The working queue for Varioqub.
    public var varioqubQueue: DispatchQueue?

    /// The queue for Varioqub callbacks.
    public var outputQueue: DispatchQueue = .main

    /// Returns the default configuration for Varioqub.
    public static var `default`: VarioqubConfig = VarioqubConfig()
}

/// The protocol that provides config-related methods.
public protocol VarioqubConfigurable: AnyObject {
    /// The callback type for the fetch methods.
    typealias FetchCallback = (VarioqubFetchAnswer) -> Void

    /// The callback type for the ``VarioqubConfigurable/activateConfig(_:)`` method.
    typealias ActivateCallback = () -> ()

    /// Fetches a new config and stores it.
    ///
    /// This method doesn't apply the config, see ``VarioqubConfigurable/activateConfig(_:)`` and ``VarioqubFacade/activateConfigAndWait()`` for that.
    ///
    /// - parameter callback: Called when fetching is completed.
    func fetchConfig(_ callback: FetchCallback?)

    /// Activates a config and notifies via a callback when it completes.
    ///
    /// This method doesn't block the callee.
    ///
    /// See also: ``VarioqubConfigurable/activateConfigAndWait()``.
    ///
    /// - parameter callback: Called when activating is completed.
    func activateConfig(_ callback: ActivateCallback?)

    /// Activates the config.
    ///
    /// This method waits for the config application.
    ///
    /// See also: ``VarioqubConfigurable/activateConfig(_:)``.
    func activateConfigAndWait()

    /// Fetches a new config and activates it.
    ///
    /// Activating a new config isn't performed if fetching it fails.
    /// If the fetch status is `` ConfigFetcherAnswer.success``, ``ConfigFetcherAnswer.throttled``, or ``ConfigFetcherAnswer.cached``, it activates a new config.
    /// - parameter callback: Notifies when fetching and activating is finished.
    func fetchAndActivateConfig(_ callback: FetchCallback?)
}

/// The protocol that provides the default related methods.
public protocol VarioqubDefaultsSetupable: AnyObject {
    /// The callback for ``VarioqubDefaultsSetupable/setDefaults(_:callback:)``.
    typealias DefaultsCallback = () -> Void

    /// The callback for XML load related methods.
    typealias XmlParserCallback = (Error?) -> Void

    /// Adds key-value pairs into the config.
    ///
    /// The server config has higher priority over these values.
    ///
    /// The method doesn't block the callee and notifies about finishing via a callback.
    ///
    /// See also: ``VarioqubFacade/setDefaultsAndWait(_:)``.
    /// - parameter defaults: The dictionary with flags and values.
    /// - parameter callback: Notifies when setting is completed.
    func setDefaults(_ defaults: [VarioqubFlag: String], callback: DefaultsCallback?)

    /// Adds key-value pairs into the config.
    ///
    /// The server config has higher priority over these values.
    ///
    /// See also: ``VarioqubFacade/setDefaults(_:callback:)``.
    /// - parameter defaults: The dictionary with flags and values.
    func setDefaultsAndWait(_ defaults: [VarioqubFlag: String])

    /// Loads key-value pairs from an XML.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(at:)``.
    ///
    /// - parameter path: The path to the XML file.
    /// - parameter callback: Notifies about finishing.
    func loadXml(at path: URL, callback: XmlParserCallback?)

    /// Loads key-value pairs from an XML.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(at:)``.
    ///
    /// - parameter path: The path to the XML file.
    func loadXmlAndWait(at path: URL) throws

    /// Loads key-value pairs from XML-encoded data.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(from:)``.
    ///
    /// - parameter data: The data that represents XML.
    /// - parameter callback: Notifies about finishing.
    func loadXml(from data: Data, callback: XmlParserCallback?)

    /// Loads key-value pairs from XML-encoded data.
    ///
    /// See details about loading and format: https://yandex.ru/support2/varioqub-app/en/sdk/ios/integration#step-3-set-the-default-configuration-using-an-xml-file
    ///
    /// See also: ``VarioqubFacade/loadXmlAndWait(at:)``.
    ///
    /// - parameter from: data that represents xml
    func loadXmlAndWait(from data: Data) throws
}

/// The protocol that provides options that can be changed any time.
// sourcery: AutoMockable
public protocol VarioqubRuntimeOptionable: AnyObject {
    /// Sets whether activate event sending is enabled. Default is true.
    var sendEventOnChangeConfig: Bool { get set }

    /// Sets client features used for experiment filtering.
    var clientFeatures: VarioqubClientFeatures { get set }
    
    var runtimeParams: VarioqubParameters { get set }
}

public typealias RuntimeOptionable = VarioqubRuntimeOptionable

public protocol VarioqubResourcesProvider: AnyObject {
    func resource(for key: VarioqubResourceKey) -> VarioqubResource?
}

public protocol VarioqubDeeplinkInput: AnyObject {
    
    @discardableResult
    func handleDeeplink(_ url: URL) -> Bool
}
