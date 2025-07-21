import Foundation

final class VarioqubSettingsProxy: ConfigFetcherSettings, NetworkDataStorable, ReporterStorable {

    private let realSettings: VarioqubSettingsProtocol

    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()

    init(realSettings: VarioqubSettingsProtocol) {
        self.realSettings = realSettings
    }

    var lastFetchDate: Date {
        get { realSettings.lastFetchDate ?? Date(timeIntervalSince1970: 0) }
        set {
            realSettings.lastFetchDate = newValue
        }
    }

    var etag: String? {
        get { realSettings.lastEtag }
        set { realSettings.lastEtag = newValue }
    }

    func saveNetworkData(_ data: NetworkDataDTO?, for key: NetworkDataKey) {
        let d: Data? = data.flatMap { try? jsonEncoder.encode($0) }
        realSettings.storeNetworkData(d, for: key.rawValue)
    }

    func loadNetworkData(for key: NetworkDataKey) -> NetworkDataDTO? {
        realSettings.loadNetworkData(for: key.rawValue).flatMap { try? jsonDecoder.decode(NetworkDataDTO.self, from: $0) }
    }

    var isShouldNotifyExperimentChanged: Bool {
        get { realSettings.isShouldNotifyExperimentChanged }
        set { realSettings.isShouldNotifyExperimentChanged = newValue }
    }

    var reporterData: ReporterData {
        get {
            let dto = realSettings.reporterData.flatMap { try? jsonDecoder.decode(ReporterDataDTO.self, from: $0) }
            return dto?.value ?? ReporterData()
        }
        set {
            let data = try? jsonEncoder.encode(newValue.dto)
            realSettings.reporterData = data
        }
    }

}
