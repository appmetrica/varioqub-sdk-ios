import XCTest
@testable import Varioqub
@testable import VarioqubNetwork
import VarioqubUtils

final class ConfigFetcherTests: XCTestCase {

    let idProvider = ConfigIdProviderMock(deviceId: "device", userId: "user")
    let internalConfig = InternalConfig(
            baseURL: URL(string: "https://example.org")!,
            clientId: "123456",
            fetchThrottle: Configuration.defaultFetchThrottleTime,
            idProviderName: "IdProviderName",
            repoterName: "ReporterName"
    )
    let mockExecutor = MockExecutor()

    var configFetcher: ConfigFetcher!
    var identifiersProvider: ConfigIdentifiersProviderMock!

    var networkClient: NetworkClientDelayMock!
    var settings: ConfigFetcherSettingsMock!
    var output: ConfigFetcherOutputMock!
    var runtimeOptions: VarioqubRuntimeOptionableMock!
    
    let envDate = Date()

    override func setUp() {
        super.setUp()

        identifiersProvider = ConfigIdentifiersProviderMock(id: "vq_id")

        networkClient = NetworkClientDelayMock()
        settings = ConfigFetcherSettingsMock()

        output = ConfigFetcherOutputMock()

        runtimeOptions = VarioqubRuntimeOptionableMock()
        runtimeOptions.clientFeatures = ClientFeatures()
        
        configFetcher = ConfigFetcher(
            networkClient: networkClient,
            idProvider: idProvider,
            config: internalConfig,
            settings: settings,
            identifiersProvider: identifiersProvider,
            executor: mockExecutor,
            output: output,
            environmentProvider: EnvironmentProviderMock(currentDate: envDate),
            runtimeOptions: runtimeOptions,
            threadChecker: ThreadChecker()
        )

    }

    func testFetchExperimentsSuccess() throws {
        let data = "success".data(using: .utf8)!

        let serverResponse = ServerResponse(
                body: data,
                statusCode: .init(rawValue: 200),
                headers: .init()
        )
        let ans = NetworkResponse.validAnswer(serverResponse)

        networkClient.mockedRequestsParams = [(ans, .milliseconds(10))]

        settings.lastFetchDate = Date(timeIntervalSince1970: 0)

        let callbackExpectation = expectation(description: "callback")
        configFetcher.fetchExperiments { result in
            callbackExpectation.fulfill()
            XCTAssert(result.isSuccess)
        }
        let expectedModel = NetworkDataModel(version: .current, data: data, fetchDate: envDate)

        waitForExpectations(timeout: 10)

        // current date in fetchExperiments equals to current date with small offset
        XCTAssert(abs(settings.lastFetchDate.timeIntervalSince1970 - Date().timeIntervalSince1970) < 3000)
        XCTAssertEqual(networkClient.makeRequestsArgs.count, 1)
        XCTAssertTrue(output.updateNetworkDataCalled)
        XCTAssertEqual(output.updateNetworkDataReceivedModel, expectedModel)
        
    }

    func testFetchExperimentsSuccessEmptyExperiment() throws {
        let serverResponse = ServerResponse(
                body: nil,
                statusCode: .init(rawValue: 304),
                headers: .init()
        )
        let ans = NetworkResponse.validAnswer(serverResponse)

        networkClient.mockedRequestsParams = [(ans, .milliseconds(10))]
        settings.lastFetchDate = Date(timeIntervalSince1970: 0)

        let callbackExpectation = expectation(description: "callback")
        configFetcher.fetchExperiments { result in
            callbackExpectation.fulfill()
            XCTAssert(result.isCached)
        }

        waitForExpectations(timeout: 10)

        XCTAssertEqual(networkClient.makeRequestsArgs.count, 1)
        XCTAssertFalse(output.updateNetworkDataCalled)
    }

    func testFetchExperimentsThrottledError() {
        let serverResponse = ServerResponse(body: nil, statusCode: .init(rawValue: 500), headers: .init())
        let ans = NetworkResponse.serverError(serverResponse)

        settings.lastFetchDate = Date()

        networkClient.mockedRequestsParams = [(ans, .milliseconds(10))]

        let callbackExpectation = expectation(description: "callback")
        configFetcher.fetchExperiments { result in
            callbackExpectation.fulfill()
            XCTAssertEqual(result.isThrottled, true)
        }

        waitForExpectations(timeout: 10)
        XCTAssertFalse(output.updateNetworkDataCalled)
    }

    func testFetchExperimentsServerError() {
        let serverResponse = ServerResponse(body: nil, statusCode: .init(rawValue: 500), headers: .init())
        let ans = NetworkResponse.serverError(serverResponse)

        settings.lastFetchDate = Date(timeIntervalSince1970: 0)

        networkClient.mockedRequestsParams = [(ans, .milliseconds(10))]

        let callbackExpectation = expectation(description: "callback")
        configFetcher.fetchExperiments { error in
            callbackExpectation.fulfill()
            XCTAssertNotNil(error)
        }

        waitForExpectations(timeout: 10)
        XCTAssertFalse(output.updateNetworkDataCalled)
    }

    func testFetchExperimentsNetworkError() {

        let ans = NetworkResponse.networkError(.connectionError(error: NetworkErrorMock()))
        networkClient.mockedRequestsParams = [(ans, .milliseconds(10))]

        settings.lastFetchDate = Date(timeIntervalSince1970: 0)

        let callbackExpectation = expectation(description: "callback")
        configFetcher.fetchExperiments { error in
            callbackExpectation.fulfill()
            XCTAssertNotNil(error)
        }

        waitForExpectations(timeout: 10)
        XCTAssertFalse(output.updateNetworkDataCalled)
    }

}
