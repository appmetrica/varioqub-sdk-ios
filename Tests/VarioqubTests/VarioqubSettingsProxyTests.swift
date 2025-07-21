import XCTest
@testable import Varioqub

final class VarioqubSettingsProxyTests: XCTestCase {

    var proxy: VarioqubSettingsProxy!
    var settings: VarioqubSettingsProtocolMock!

    let networkDataJSON = """
                          {
                            "experimentId": "experiment_id",
                            "id": "vq_id",
                            "flags": [
                              { "flag": "feature1", "value": "123", "testId": 234 },
                              { "flag": "feature2", "value": "true", "testId": 345 },
                              { "flag": "feature3", "value": "asd", "testId": 456 },
                            ] 
                          }
                    """

    let networkData: NetworkDataDTO = .init(id: "vq_id",
            experimentId: "experiment_id",
            flags: [
                .init(flag: "feature1", value: "123", testId: 234),
                .init(flag: "feature2", value: "true", testId: 345),
                .init(flag: "feature3", value: "asd", testId: 456),
            ]
    )

    let networkDataMock: NetworkDataDTOMock = .init(
            id: "vq_id",
            experimentId: "experiment_id",
            flags: [
                .init(flag: "feature1", value: "123", testId: 234),
                .init(flag: "feature2", value: "true", testId: 345),
                .init(flag: "feature3", value: "asd", testId: 456),
            ]
    )

    let flags: [VarioqubFlag: VarioqubTransferValue] = [
        "feature1": .init(value: .init(string: "123"), testId: 234),
        "feature2": .init(value: .init(string: "true"), testId: 345),
        "feature3": .init(value: .init(string: "asd"), testId: 456),
    ]

    let mockedFlags: [FlagValueDTOMock] = [
        .init(flag: "feature1", value: "123", testId: 234),
        .init(flag: "feature2", value: "true", testId: 345),
        .init(flag: "feature3", value: "asd", testId: 456),
    ]

    override func setUp() {
        super.setUp()

        settings = VarioqubSettingsProtocolMock()
        proxy = VarioqubSettingsProxy(realSettings: settings)
    }

    func testGetLastFetchDateNil() {
        settings.lastFetchDate = nil

        XCTAssertEqual(proxy.lastFetchDate, Date(timeIntervalSince1970: 0))
    }

    func testGetLastFetchDateNonNil() {
        let d = Date()

        settings.lastFetchDate = d
        XCTAssertEqual(proxy.lastFetchDate, d)
    }

    func testSetLastFetchDate() {
        let d = Date()

        proxy.lastFetchDate = d
        XCTAssertEqual(settings.lastFetchDate, d)
    }

    func testLoadNetworkData() {
        settings.loadNetworkDataForClosure = { [networkDataJSON] _ in networkDataJSON.data(using: .utf8) }

        XCTAssertEqual(proxy.loadNetworkData(for: .pending), networkData)
    }

    func testSaveNetworkData() {
        proxy.saveNetworkData(networkData, for: .pending)

        let jsonDecoder = JSONDecoder()
        
        XCTAssertEqual(settings.storeNetworkDataForReceivedArguments?.data.flatMap { try? jsonDecoder.decode(NetworkDataDTOMock.self, from: $0) }, networkDataMock)
        XCTAssertEqual(settings.storeNetworkDataForReceivedArguments?.key, "pending")
    }

}

struct FlagValueDTOMock: Codable, Hashable, Equatable {
    var flag: String
    var value: String
    var testId: Int64?
}

struct NetworkDataDTOMock: Codable, Equatable {
    var id: String
    var experimentId: String?
    var flags: [FlagValueDTOMock]
}
