import XCTest
@testable import Varioqub
import VarioqubUtils

final class VarioqubInternalImplTests: XCTestCase {

    var impl: VarioqubInternalImpl!
    var configFetcher: ConfigFetchableMock!
    var flagUpdater: ConfigUpdaterInputMock!
    var flagResolver: ConfigUpdaterControllableMock!

    override func setUp() {
        super.setUp()

        configFetcher = ConfigFetchableMock()
        configFetcher.fetchExperimentsCallbackClosure = { $0?(.success) }

        flagUpdater = ConfigUpdaterInputMock()
        flagResolver = ConfigUpdaterControllableMock()

        let factory = MainFactoryProtocolStub()
        factory._configFetcher = configFetcher
        factory._flagUpdater = flagUpdater
        factory._flagResolver = flagResolver
        factory._threadChecker = ThreadChecker(queue: nil)

        impl = VarioqubInternalImpl(mainFactory: factory)
    }

    func testFetch() {
        let callbackExpectation = expectation(description: "callback")
        impl.fetchConfig {  _ in
            callbackExpectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testActivate() {
        impl.activateConfig(nil)
        XCTAssert(flagResolver.activateConfigCalled)
    }

    func testFetchSuccessAndActivate() {

        let fetchExperimentsExpectation = expectation(description: "fetchExperiments")

        configFetcher.fetchExperimentsCallbackClosure = { [weak self] in
            guard let self else { fatalError() }
            fetchExperimentsExpectation.fulfill()

            XCTAssertFalse(self.flagResolver.activateConfigCalled)

            $0?(.success)
        }

        impl.fetchAndActivateConfig(nil)

        waitForExpectations(timeout: 1)

        XCTAssertTrue(configFetcher.fetchExperimentsCallbackCalled)
        XCTAssertTrue(flagResolver.activateConfigCalled)
    }

    func testFetchErrorAndActivate() {

        let fetchExperimentsExpectation = expectation(description: "fetchExperiments")

        configFetcher.fetchExperimentsCallbackClosure = { [weak self] in
            guard let self else { fatalError() }
            fetchExperimentsExpectation.fulfill()

            XCTAssertFalse(self.flagResolver.activateConfigCalled)

            $0?(.error(.network(StubError())))
        }

        impl.fetchAndActivateConfig(nil)

        waitForExpectations(timeout: 1)

        XCTAssertTrue(configFetcher.fetchExperimentsCallbackCalled)
        XCTAssertFalse(flagResolver.activateConfigCalled)
    }

    func setDefaultsTest() {
        let defFlags: [VarioqubFlag: String] = [
            "feature1": "123",
            "feature2": "asd",
            "feature3": "true",
        ]
        let defValues = defFlags.mapValues { VarioqubValue(string: $0) }

        let callbackExpectation = expectation(description: "callback")
        impl.setDefaults(defFlags) {
            callbackExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)

        XCTAssertTrue(flagUpdater.updateDefaultsFlagsCalled)
        XCTAssertEqual(flagUpdater.updateDefaultsFlagsReceivedFlags, defValues)
    }

}
