import XCTest
@testable import Varioqub
import VarioqubUtils

final class ConfigUpdaterTests: XCTestCase {

    var configUpdater: ConfigUpdater!
    var output: ConfigUpdaterOutputMock!
    var reporter: ConfigUpdaterFlagReporterMock!
    var persistentStorage: NetworkDataStorableMock!

    let testFlags: [VarioqubFlag: VarioqubTransferValue] = [
        VarioqubFlag(rawValue: "test1"): VarioqubTransferValue(value: .init(string: "1"), testId: 1),
        VarioqubFlag(rawValue: "test2"): VarioqubTransferValue(value: .init(string: "2"), testId: 2),
        VarioqubFlag(rawValue: "test3"): VarioqubTransferValue(value: .init(string: "3"), testId: 3),
    ]

    override func setUp() {
        super.setUp()

        output = ConfigUpdaterOutputMock()
        reporter = ConfigUpdaterFlagReporterMock()
        persistentStorage = NetworkDataStorableMock()
        configUpdater = ConfigUpdater(output: output,
                reporter: reporter,
                persistentStorage: persistentStorage,
                threadChecker: ThreadChecker()
        )
    }

    func testUpdateNetworkData() {

        let date = Date(timeIntervalSince1970: 100500)
        
        let networkData = NetworkData(
            flags: testFlags,
            experimentId: "vq_id",
            id: "id",
            configVersion: "ver1",
            fetchDate: date
        )
        let networkDataDTO = NetworkDataDTO(
            id: "id",
            experimentId: "vq_id",
            flags: testFlags.map {
                NetworkDataDTO.Value(flag: $0.key.rawValue, value: $0.value.value?.rawValue, testId: $0.value.testId?.rawValue)
                
            },
            configVersion: "ver1",
            fetchDate: Int64(date.timeIntervalSince1970)
        )

        configUpdater.updateNetworkData(networkData)

        XCTAssertFalse(reporter.configAppliedOldConfigNewConfigCalled)

        XCTAssertTrue(persistentStorage.saveNetworkDataForCalled)
        XCTAssertEqual(persistentStorage.saveNetworkDataForReceivedArguments?.data, networkDataDTO)
        XCTAssertEqual(persistentStorage.saveNetworkDataForReceivedArguments?.key, .pending)

    }

    func testUpdateNetworkDataAndActivate() {

        let currentDate = Date()
        let networkData = NetworkData(
            flags: testFlags,
            experimentId: "vq_id",
            id: "id",
            configVersion: "ver1",
            fetchDate: currentDate
        )
        let networkDataDTO = NetworkDataDTO(
            id: "id",
            experimentId: "vq_id",
            flags: testFlags.map {
                NetworkDataDTO.Value(flag: $0.key.rawValue, value: $0.value.value?.rawValue, testId: $0.value.testId?.rawValue)
                
            },
            configVersion: "ver1",
            fetchDate: Int64(currentDate.timeIntervalSince1970)
        )

        configUpdater.updateNetworkData(networkData)
        configUpdater.activateConfig()

        XCTAssertTrue(reporter.configAppliedOldConfigNewConfigCalled)
        XCTAssertEqual(reporter.configAppliedOldConfigNewConfigReceivedArguments?.newConfig, networkData)

        XCTAssertTrue(persistentStorage.saveNetworkDataForCalled)
        XCTAssertEqual(persistentStorage.saveNetworkDataForReceivedArguments?.data, networkDataDTO)
        XCTAssertEqual(persistentStorage.saveNetworkDataForReceivedArguments?.key, .active)

    }

}
