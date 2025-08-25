import XCTest
@testable import Varioqub
import VarioqubUtils

final class VarioqubInternalImplTests: XCTestCase {

    var impl: VarioqubInternalImpl!
    
    var configFetcher: ConfigFetchableMock!
    var slotController: SlotHolderControlableMock!
    var flagController: FlagControllerParamsInputMock!
    var runtimeOptions: RuntimeOptionsMock!
    
    override func setUp() {
        super.setUp()

        configFetcher = ConfigFetchableMock()
        configFetcher.fetchExperimentsCallbackClosure = { $0?(.success) }
        
        slotController = SlotHolderControlableMock()
        
        flagController = FlagControllerParamsInputMock()
        
        runtimeOptions = RuntimeOptionsMock()

        impl = VarioqubInternalImpl(
            configFetcher: configFetcher,
            slotController: slotController,
            flagController: flagController,
            runtimeOptions: runtimeOptions,
            threadChecker: ThreadChecker()
        )
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
        XCTAssert(slotController.activateConfigCalled)
    }

    func testFetchSuccessAndActivate() {

        let fetchExperimentsExpectation = expectation(description: "fetchExperiments")

        configFetcher.fetchExperimentsCallbackClosure = { [weak self] in
            guard let self else { fatalError() }
            fetchExperimentsExpectation.fulfill()

            XCTAssertFalse(self.slotController.activateConfigCalled)

            $0?(.success)
        }

        impl.fetchAndActivateConfig(nil)

        waitForExpectations(timeout: 1)

        XCTAssertTrue(configFetcher.fetchExperimentsCallbackCalled)
        XCTAssertTrue(slotController.activateConfigCalled)
    }

    func testFetchErrorAndActivate() {

        let fetchExperimentsExpectation = expectation(description: "fetchExperiments")

        configFetcher.fetchExperimentsCallbackClosure = { [weak self] in
            guard let self else { fatalError() }
            fetchExperimentsExpectation.fulfill()

            XCTAssertFalse(self.slotController.activateConfigCalled)

            $0?(.error(.network(StubError())))
        }

        impl.fetchAndActivateConfig(nil)

        waitForExpectations(timeout: 1)

        XCTAssertTrue(configFetcher.fetchExperimentsCallbackCalled)
        XCTAssertFalse(slotController.activateConfigCalled)
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

        XCTAssertTrue(flagController.updateDefaultValuesCalled)
        XCTAssertEqual(flagController.updateDefaultValuesReceivedDefaultValues, defValues)
    }

}
