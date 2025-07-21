
import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public protocol VQSettingsProtocol: NSObjectProtocol {
    var lastFetchDate: Date? { get set }
    var isShouldNotifyExperimentChanged: Bool { get set }
    var lastEtag: String? { get set }
    var reporterData: Data? { get set }
    func storeNetworkData(_ data: Data?, for key: String)
    func loadNetworkData(for key: String) -> Data?
}

@objc
public protocol VQSettingsFactory: NSObjectProtocol {
    func create(for clientId: String) -> VQSettingsProtocol
}

@objc
public class VQClientFeatures: NSObject, NSCopying, NSMutableCopying {
    
    var clientFeatures: ClientFeatures
    
    init(clientFeatures: ClientFeatures) {
        self.clientFeatures = clientFeatures
    }
    
    @objc
    public required init(dictionary: [String: String]) {
        self.clientFeatures = .init(dictionary: dictionary)
        super.init()
    }
    
    @objc
    public var features: [String: String] { return clientFeatures.features }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        return VQMutableClientFeatures(clientFeatures: clientFeatures)
    }
    
    @objc
    public class func clientFeatures(with dict: [String: String]) -> Self {
        return Self.init(dictionary: dict)
    }
    
}

@objc
public final class VQMutableClientFeatures: VQClientFeatures {
    
    @objc
    public func setFeature(_ feature: String, forKey key: String) {
        clientFeatures.setFeature(feature, forKey: key)
    }
    
    @objc
    public func removeFeature(forKey key: String) {
        clientFeatures.removeFeature(forKey: key)
    }
    
    @objc
    public func mergeWith(_ other: [String: String]) {
        clientFeatures.mergeWith(other)
    }
    
    @objc
    public func clearFeatures() {
        clientFeatures.clearFeatures()
    }
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        return VQClientFeatures(clientFeatures: clientFeatures)
    }
    
    public override func mutableCopy(with zone: NSZone? = nil) -> Any {
        return VQMutableClientFeatures(clientFeatures: clientFeatures)
    }
    
}

@objc
public final class VQConfig: NSObject {

    @objc
    public var baseURL: URL?

    @objc
    public var settingsFactory: VQSettingsFactory?

    @objc
    public var fetchThrottle: TimeInterval = 0

    @objc
    public var initialClientFeatures: VQClientFeatures?

    @objc
    public var varioqubQueue: DispatchQueue?

    @objc
    public var outputQueue: DispatchQueue = .main

    private override init() {
        super.init()
    }

    @objc(defaultConfig)
    public static var `default`: VQConfig { VQConfig() }

}

extension VQConfig {

    var varioqubConfig: VarioqubConfig {
        var cfg = VarioqubConfig.default

        cfg.baseURL = baseURL
        cfg.settingsFactory = settingsFactory.map { VQSettingsFactoryProxy(factory: $0) }
        if fetchThrottle > 0 {
            cfg.fetchThrottle = fetchThrottle
        }
        cfg.initialClientFeatures = .init(dictionary: initialClientFeatures?.features ?? [:])
        cfg.varioqubQueue = varioqubQueue
        cfg.outputQueue = outputQueue

        return cfg
    }

}
