import XCTest
@testable import Varioqub

final class FlagResolverTests: XCTestCase {

    let dataset1: [VarioqubFlag: VarioqubConfigValue] = [
        .init(rawValue: "feature1"): VarioqubConfigValue(source: .server, value: .init(string: "123"), triggeredTestID: 123),
        .init(rawValue: "feature2"): VarioqubConfigValue(source: .inappDefault, value: .init(string: "ooo"), triggeredTestID: nil),
        .init(rawValue: "feature3"): VarioqubConfigValue(source: .server, value: .init(string: "true"), triggeredTestID: 234),    ]

    let dataset2: [VarioqubFlag: VarioqubConfigValue] = [
        .init(rawValue: "feature4"): VarioqubConfigValue(source: .server, value: .init(string: "234"), triggeredTestID: 456),
        .init(rawValue: "feature5"): VarioqubConfigValue(source: .inappDefault, value: .init(string: "uuuu"), triggeredTestID: nil),
        .init(rawValue: "feature6"): VarioqubConfigValue(source: .server, value: .init(string: "false"), triggeredTestID: 555),
    ]

    let dataset3: [VarioqubFlag: VarioqubConfigValue] = [
        .init(rawValue: "feature7"): VarioqubConfigValue(source: .server, value: .init(string: "345"), triggeredTestID: 567),
        .init(rawValue: "feature8"): VarioqubConfigValue(source: .inappDefault, value: .init(string: "zzzz"), triggeredTestID: nil),
        .init(rawValue: "feature9"): VarioqubConfigValue(source: .server, value: .init(string: "qwerty"), triggeredTestID: 888),
    ]

    var flagResolver: FlagResolver!
    var output: FlagResolverOutputMock!

    override func setUp() {
        super.setUp()
        output = FlagResolverOutputMock()
        flagResolver = FlagResolver(output: output, executor: MockExecutor())
    }

    func testDefaultFlags() {

        XCTAssertTrue(flagResolver.getValue(for: "feature1").isDefault)
        XCTAssertTrue(flagResolver.getValue(for: "feature4").isDefault)
        XCTAssertTrue(flagResolver.getValue(for: "feature").isDefault)
        XCTAssertEqual(flagResolver.allItems, [:])
        XCTAssertEqual(flagResolver.allKeys, [])
    }

    func testFlagsAfterUpdate() {
        flagResolver.updateFlags(dataset1)

        XCTAssertEqual(flagResolver.getValue(for: "feature1"), VarioqubConfigValue(source: .server, value: .init(string: "123"), triggeredTestID: 123))
        XCTAssertEqual(flagResolver.getValue(for: "feature2"), VarioqubConfigValue(source: .inappDefault, value: .init(string: "ooo"), triggeredTestID: nil))
        XCTAssertEqual(flagResolver.getValue(for: "feature3"), VarioqubConfigValue(source: .server, value: .init(string: "true"), triggeredTestID: 234))
        XCTAssertTrue(flagResolver.getValue(for: "feature4").isDefault)
        XCTAssertTrue(flagResolver.getValue(for: "feature").isDefault)
        XCTAssertEqual(flagResolver.allItems, dataset1)
        XCTAssertEqual(flagResolver.allKeys, Set(dataset1.keys))
    }


    func testFlagsAfterTwiceUpdated() {

        flagResolver.updateFlags(dataset1)
        flagResolver.updateFlags(dataset2)

        // dataset1 was dropped
        // dataset2 is active now

        XCTAssertTrue(flagResolver.getValue(for: "feature1").isDefault)
        XCTAssertTrue(flagResolver.getValue(for: "feature").isDefault)
        XCTAssertEqual(flagResolver.getValue(for: "feature4"), VarioqubConfigValue(source: .server, value: .init(string: "234"), triggeredTestID: 456))
        XCTAssertEqual(flagResolver.getValue(for: "feature5"), VarioqubConfigValue(source: .inappDefault, value: .init(string: "uuuu"), triggeredTestID: nil))
        XCTAssertEqual(flagResolver.getValue(for: "feature6"), VarioqubConfigValue(source: .server, value: .init(string: "false"), triggeredTestID: 555))
        XCTAssertEqual(flagResolver.allItems, dataset2)
        XCTAssertEqual(flagResolver.allKeys, Set(dataset2.keys))

    }

    func testTriggeredServerValue() {
        flagResolver.updateFlags(dataset1)

        _ = flagResolver.getValue(for: "feature1")
        XCTAssertTrue(output.testIdTriggeredCalled)
        XCTAssertEqual(output.testIdTriggeredCallsCount, 1)
        XCTAssertEqual(output.testIdTriggeredReceivedTestId, 123)
    }

    func testNotTriggeredUserDefaultValue() {
        flagResolver.updateFlags(dataset1)

        _ = flagResolver.getValue(for: "feature2")
        XCTAssertFalse(output.testIdTriggeredCalled)
    }

}
