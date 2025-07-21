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
    var output: ConfigUpdaterInputMock!
    var runtimeOptions: RuntimeOptionableMock!
    
    let envDate = Date()

    override func setUp() {
        super.setUp()

        identifiersProvider = ConfigIdentifiersProviderMock(id: "vq_id")

        networkClient = NetworkClientDelayMock()
        settings = ConfigFetcherSettingsMock()

        output = ConfigUpdaterInputMock()

        runtimeOptions = RuntimeOptionableMock()
        runtimeOptions.clientFeatures = ClientFeatures()
        
        configFetcher = ConfigFetcher(networkClient: networkClient,
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
        let pbResponse = createResponse(experiments: "experiment", version: "ver1")

        let serverResponse = ServerResponse(
                body: try! pbResponse.serializedData(),
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

        waitForExpectations(timeout: 10)

        // current date in fetchExperiments equals to current date with small offset
        XCTAssert(abs(settings.lastFetchDate.timeIntervalSince1970 - Date().timeIntervalSince1970) < 3000)

        XCTAssertEqual(networkClient.makeRequestsArgs.count, 1)
        let restoredRequest = try PBRequest(contiguousBytes: networkClient.makeRequestsArgs.last!.body!)

        XCTAssertEqual(restoredRequest.id, identifiersProvider.varioqubIdentifier)
        XCTAssertEqual(restoredRequest.deviceID, idProvider.deviceId)
        XCTAssertEqual(restoredRequest.userID, idProvider.userId)

        let expectedNetworkData = NetworkData(
                flags: .init(uniqueKeysWithValues: pbResponse.flags.map {
                    let key = VarioqubFlag(rawValue: $0.name)
                    let value = VarioqubValue(string: $0.values.last!.value)
                    let testId = $0.values.last!.hasTestID ? VarioqubTestID(rawValue: $0.values.last!.testID) : nil
                    return (key, VarioqubTransferValue(value: value, testId: testId))
                }),
                experimentId: pbResponse.experiments,
                id: pbResponse.id,
                configVersion: "ver1",
                fetchDate: envDate
        )
        XCTAssertEqual(output.updateNetworkDataReceivedData, expectedNetworkData)
    }

    func testFetchExperimentsSuccessEmptyExperiment() throws {
        let pbResponse = createResponse(experiments: "", version: "")

        let serverResponse = ServerResponse(
                body: try! pbResponse.serializedData(),
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

        waitForExpectations(timeout: 10)

        XCTAssertEqual(networkClient.makeRequestsArgs.count, 1)
        let restoredRequest = try PBRequest(contiguousBytes: networkClient.makeRequestsArgs.last!.body!)

        XCTAssertEqual(restoredRequest.id, identifiersProvider.varioqubIdentifier)
        XCTAssertEqual(restoredRequest.deviceID, idProvider.deviceId)
        XCTAssertEqual(restoredRequest.userID, idProvider.userId)

        let expectedNetworkData = NetworkData(
                flags: .init(uniqueKeysWithValues: pbResponse.flags.map {
                    let key = VarioqubFlag(rawValue: $0.name)
                    let value = VarioqubValue(string: $0.values.last!.value)
                    let testId = $0.values.last!.hasTestID ? VarioqubTestID(rawValue: $0.values.last!.testID) : nil
                    return (key, VarioqubTransferValue(value: value, testId: testId))
                }),
                experimentId: pbResponse.experiments,
                id: pbResponse.id,
                configVersion: "",
                fetchDate: envDate
        )
        XCTAssertEqual(output.updateNetworkDataReceivedData, expectedNetworkData)
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

//        XCTAssertFalse(experimentOutput.setExperimentsCalled)
    }

}

func createResponse(experiments: String, version: String) -> PBResponse {
    let pbResponse = PBResponse.with {
        $0.experiments = experiments
        $0.configVersion = version
        $0.id = "i"
        $0.flags = [
            PBFlag.with {
                $0.name = "feature1"
                $0.values = [
                    PBValue.with {
                        $0.testID = 901
                        $0.value = "true"
                    },
                    PBValue.with {
                        $0.testID = 902
                        $0.value = "false"
                    },
                ]
            },
            PBFlag.with {
                $0.name = "feature2"
                $0.values = [
                    PBValue.with {
                        $0.testID = 801
                        $0.value = "123"
                    },
                    PBValue.with {
                        $0.testID = 802
                        $0.value = "234"
                    },
                ]
            },
            PBFlag.with {
                $0.name = "feature3"
                $0.values = [
                    PBValue.with {
                        $0.testID = 701
                        $0.value = "qqq"
                    },
                    PBValue.with {
                        $0.testID = 702
                        $0.value = "www"
                    },
                ]
            },
        ]
    }

    return pbResponse
}
