
import Foundation

struct NetworkDataDTO: Codable {
    struct Value: Codable {
        var flag: String
        var value: String?
        var testId: Int64?
    }

    var id: String
    var experimentId: String?
    var flags: [Value]
    var configVersion: String?
    var fetchDate: Int64?
}

struct NetworkDataKey: RawRepresentable, Equatable {
    var rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    static let pending: NetworkDataKey = .init(rawValue: "pending")
    static let active: NetworkDataKey = .init(rawValue: "active")
}

// sourcery: AutoMockable
protocol NetworkDataStorable: AnyObject {
    func saveNetworkData(_ data: NetworkDataDTO?, for key: NetworkDataKey)
    func loadNetworkData(for key: NetworkDataKey) -> NetworkDataDTO?

    var isShouldNotifyExperimentChanged: Bool { get set }
}
