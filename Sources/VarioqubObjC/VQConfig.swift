
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
public final class VQConfig: NSObject {

    @objc
    public var baseURL: URL?

    @objc
    public var settingsFactory: VQSettingsFactory?

    @objc
    public var fetchThrottle: TimeInterval = 0

    @objc
    public var initialClientFeatures: VQVarioqubClientFeatures?

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
