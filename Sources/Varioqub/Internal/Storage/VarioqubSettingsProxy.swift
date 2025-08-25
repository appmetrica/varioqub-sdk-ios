import Foundation

final class VarioqubSettingsProxy: ConfigFetcherSettings, ReporterStorable {

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

    var reporterData: ReporterDataDTO {
        get {
            let dto = realSettings.reporterData.flatMap { try? jsonDecoder.decode(ReporterDataDSO.self, from: $0) }
            return dto?.value ?? ReporterDataDTO()
        }
        set {
            let data = try? jsonEncoder.encode(newValue.dto)
            realSettings.reporterData = data
        }
    }

}
