import XCTest
@testable import Varioqub
import VarioqubUtils


final class ConfigUpdaterFlagsTests: XCTestCase {

    var configUpdater: ConfigUpdater!
    var outputMock: ConfigUpdaterOutputMock!
    var reporter: ConfigUpdaterFlagReporterMock!
    var persistentStorage: NetworkDataStorableMock!

    let ndataset1: [VarioqubFlag: VarioqubTransferValue] = [
        .init(rawValue: "feature1"): .init(value: .init(string: "qwe"), testId: .init(rawValue: 123)),
        .init(rawValue: "feature2"): .init(value: nil, testId: .init(rawValue: 234)),
        .init(rawValue: "feature3"): .init(value: .init(string: "123"), testId: .init(rawValue: 345)),
    ]

    let ndataset1CV: [VarioqubFlag: VarioqubConfigValue] = [
        .init(rawValue: "feature1"): VarioqubConfigValue(source: .server, value: .init(string: "qwe"), triggeredTestID: .init(rawValue: 123)),
        .init(rawValue: "feature2"): VarioqubConfigValue(source: .server, value: nil, triggeredTestID: .init(rawValue: 234)),
        .init(rawValue: "feature3"): VarioqubConfigValue(source: .server, value: .init(string: "123"), triggeredTestID: .init(rawValue: 345)),
    ]

    let ndataset2: [VarioqubFlag: VarioqubTransferValue] = [
        .init(rawValue: "feature2"): .init(value: .init(string: "true"), testId: .init(rawValue: 234)),
        .init(rawValue: "feature3"): .init(value: .init(string: "123"), testId: .init(rawValue: 345)),
        .init(rawValue: "feature4"): .init(value: .init(string: "zxc"), testId: .init(rawValue: 567)),
        .init(rawValue: "feature5"): .init(value: nil, testId: .init(rawValue: 678)),
    ]

    let ndataset2CV: [VarioqubFlag: VarioqubConfigValue] = [
        .init(rawValue: "feature2"): VarioqubConfigValue(source: .server, value: .init(string: "true"), triggeredTestID: .init(rawValue: 234)),
        .init(rawValue: "feature3"): VarioqubConfigValue(source: .server, value: .init(string: "123"), triggeredTestID: .init(rawValue: 345)),
        .init(rawValue: "feature4"): VarioqubConfigValue(source: .server, value: .init(string: "zxc"), triggeredTestID: .init(rawValue: 567)),
        .init(rawValue: "feature5"): VarioqubConfigValue(source: .server, value: nil, triggeredTestID: .init(rawValue: 678)),
    ]

    let ddataset1: [VarioqubFlag: VarioqubValue] = [
        .init(rawValue: "feature1"): .init(string: "wer"),
        .init(rawValue: "feature2"): .init(string: "false"),
        .init(rawValue: "feature3"): .init(string: "234"),
    ]

    lazy var ddataset1CV: [VarioqubFlag: VarioqubConfigValue] = ddataset1.mapValues { VarioqubConfigValue(source: .inappDefault, value: $0, triggeredTestID: nil) }

    let ddataset1ext: [VarioqubFlag: VarioqubValue] = [
        .init(rawValue: "feature1"): .init(string: "wer"),
        .init(rawValue: "feature2"): .init(string: "false"),
        .init(rawValue: "feature3"): .init(string: "234"),
        .init(rawValue: "featureext"): .init(string: "789"),
    ]

    override func setUp() {
        super.setUp()

        outputMock = ConfigUpdaterOutputMock()
        reporter = ConfigUpdaterFlagReporterMock()
        persistentStorage = NetworkDataStorableMock()

        configUpdater = ConfigUpdater(
                output: outputMock,
                reporter: reporter,
                persistentStorage: persistentStorage,
                threadChecker: ThreadChecker()
        )
    }

    func testFlagsWithoutActivating() {
        configUpdater.updateNetworkData(.init(flags: ndataset1, experimentId: nil, id: "", configVersion: ""))
        configUpdater.updateDefaultsFlags([:])

        XCTAssertTrue(outputMock.updateFlagsReceivedOutput!.isEmpty)
    }

    func testDefaultFlagsWithoutActivating() {
        configUpdater.updateNetworkData(.init(flags: ndataset2, experimentId: nil, id: "", configVersion: ""))
        configUpdater.updateDefaultsFlags(ddataset1)

        XCTAssertEqual(outputMock.updateFlagsReceivedOutput, ddataset1CV)
    }

    func testMergeEmptyFlags() {
        configUpdater.updateNetworkData(.init(flags: [:], experimentId: nil, id: "", configVersion: ""))
        configUpdater.updateDefaultsFlags([:])
        configUpdater.activateConfig()

        XCTAssertTrue(outputMock.updateFlagsReceivedOutput!.isEmpty)
    }

    func testUpdateNetworkDataAndActivate() {
        configUpdater.updateNetworkData(.init(flags: ndataset1, experimentId: nil, id: "", configVersion: ""))
        configUpdater.updateDefaultsFlags([:])
        configUpdater.activateConfig()

        var result = ndataset1CV
        result["feature2"] = VarioqubConfigValue(source: .defaultValue, value: nil, triggeredTestID: 234)

        XCTAssertEqual(outputMock.updateFlagsReceivedOutput, result)
    }

    func testReplaceNetworkFlags() {
        configUpdater.updateNetworkData(.init(flags: ndataset1, experimentId: nil, id: "", configVersion: ""))
        configUpdater.updateDefaultsFlags([:])
        configUpdater.activateConfig()

        configUpdater.updateNetworkData(.init(flags: ndataset2, experimentId: nil, id: "", configVersion: ""))

        var result = ndataset1CV
        result["feature2"] = VarioqubConfigValue(source: .defaultValue, value: nil, triggeredTestID: 234)

        XCTAssertEqual(outputMock.updateFlagsReceivedOutput, result)
    }

    func testReplaceNetworkFlagsAndActivated() {
        configUpdater.updateNetworkData(.init(flags: ndataset1, experimentId: nil, id: "", configVersion: ""))
        configUpdater.updateDefaultsFlags([:])
        configUpdater.updateNetworkData(.init(flags: ndataset2, experimentId: nil, id: "", configVersion: ""))

        configUpdater.activateConfig()

        var result = ndataset2CV
        result["feature5"] = VarioqubConfigValue(source: .defaultValue, value: nil, triggeredTestID: 678)

        XCTAssertEqual(outputMock.updateFlagsReceivedOutput, result)
    }

    func testOverrideNetworkDefaultsFlagsAfterActivation() {
        configUpdater.updateNetworkData(.init(flags: ndataset1, experimentId: nil, id: "", configVersion: ""))
        configUpdater.updateDefaultsFlags(ddataset1)

        configUpdater.activateConfig()

        var resultValue = ndataset1CV
        resultValue[.init(rawValue: "feature2")] = .init(source: .inappDefault, value: .init(string: "false"), triggeredTestID: 234)

        XCTAssertEqual(outputMock.updateFlagsReceivedOutput!, resultValue)
    }

    func testOverrideDefaultsNetworkFlags() {
        configUpdater.updateDefaultsFlags(ddataset1)
        configUpdater.updateNetworkData(.init(flags: ndataset1, experimentId: nil, id: "", configVersion: ""))

        configUpdater.activateConfig()

        var resultValue = ndataset1CV
        resultValue[.init(rawValue: "feature2")] = VarioqubConfigValue(source: .inappDefault, value: .init(string: "false"), triggeredTestID: 234)

        XCTAssertEqual(outputMock.updateFlagsReceivedOutput!, resultValue)
    }

    func testMergeDefaultsNetworkFlags() {
        configUpdater.updateDefaultsFlags(ddataset1ext)
        configUpdater.updateNetworkData(.init(flags: ndataset1, experimentId: nil, id: "", configVersion: ""))

        configUpdater.activateConfig()

        var expected: [VarioqubFlag: VarioqubConfigValue] = ndataset1CV
        expected[.init(rawValue: "featureext")] = VarioqubConfigValue(source: .inappDefault, value: .init(string: "789"), triggeredTestID: nil)
        expected[.init(rawValue: "feature2")] = VarioqubConfigValue(source: .inappDefault, value: .init(string: "false"), triggeredTestID: 234)

        XCTAssertEqual(outputMock.updateFlagsReceivedOutput!, expected)
    }

}
