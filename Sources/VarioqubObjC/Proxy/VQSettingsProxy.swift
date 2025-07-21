
import Foundation
#if VQ_MODULES
import Varioqub
#endif

final class VQSettingsProxy: VarioqubSettingsProtocol {
    let objcProtocol: VQSettingsProtocol

    init(objcProtocol: VQSettingsProtocol) { self.objcProtocol = objcProtocol }
    
    var lastFetchDate: Date? {
        get { objcProtocol.lastFetchDate }
        set { objcProtocol.lastFetchDate = newValue }
    }

    func storeNetworkData(_ data: Data?, for key: String) {
        objcProtocol.storeNetworkData(data, for: key)
    }

    func loadNetworkData(for key: String) -> Data? {
        objcProtocol.loadNetworkData(for: key)
    }

    var isShouldNotifyExperimentChanged: Bool {
        get { objcProtocol.isShouldNotifyExperimentChanged }
        set { objcProtocol.isShouldNotifyExperimentChanged = newValue }
    }

    var lastEtag: String? {
        get { objcProtocol.lastEtag }
        set { objcProtocol.lastEtag = newValue }
    }

    var reporterData: Data? {
        get { objcProtocol.reporterData }
        set { objcProtocol.reporterData = newValue }
    }
}

final class VQSettingsFactoryProxy: NSObject, VarioqubSettingsFactory {
    let factory: VQSettingsFactory
    init(factory: VQSettingsFactory) {
        self.factory = factory
    }
    
    func createSettings(for clientId: String) -> any VarioqubSettingsProtocol {
        return VQSettingsProxy(objcProtocol: factory.create(for: clientId))
    }
    
}
