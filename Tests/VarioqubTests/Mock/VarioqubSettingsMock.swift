
import Foundation
@testable import Varioqub

final class VarioqubSettingsMock: VarioqubSettingsProtocol {
    
    var lastFetchDate: Date?
    var isShouldNotifyExperimentChanged: Bool = false

    var lastEtag: String?
    var reporterData: Data?

    var networkModels: [String: Data] = [:]
    var networkDSODict: [String: Data] = [:]
    
    func storeNetworkModel(_ data: Data?, for key: String) {
        networkModels[key] = data
    }
    
    func loadNetworkModel(for key: String) -> Data? {
        return networkModels[key]
    }
    
    func storeNetworkDSOv0(_ data: Data?, for key: String) {
        networkDSODict[key] = data
    }

    func loadNetworkDSOv0(for key: String) -> Data? {
        return networkDSODict[key]
    }
    
}
