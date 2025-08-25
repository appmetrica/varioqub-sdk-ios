import XCTest
@testable import Varioqub
@testable import VarioqubNetwork
import VarioqubUtils

final class ConfigFetcherRequestTests: XCTestCase {

    var configFetcher: ConfigFetcher!

    let clientFeatures = ClientFeatures(dictionary: [
        "feature1": "value1",
        "feature2": "value2",
    ])
    
    let mockExecutor = MockExecutor()
    let idProvider = ConfigIdProviderMock(deviceId: "device", userId: "user")
    private lazy var internalConfig = InternalConfig(
        baseURL: URL(string: "https://example.org")!,
        clientId: "123456",
        fetchThrottle: 0,
        idProviderName: "IdProviderName",
        repoterName: "RepoterName"
    )
    let envDate = Date()
    lazy var envProvider = EnvironmentProviderMock(currentDate: envDate)
    var networkClient: NetworkRequestCreatorMock!
    var settings: ConfigFetcherSettingsMock!
    var identifiersProvider: ConfigIdentifiersProviderMock!
    var configFetcherOutput: ConfigFetcherOutputMock!
    var runtimeOptionable: VarioqubRuntimeOptionableMock!

    override func setUp() {
        super.setUp()

        identifiersProvider = ConfigIdentifiersProviderMock(id: "vq_id")

        let request = NetworkRequestableMock()
        request.executeReturnValue = request
        request.onCallbackReturnValue = request

        networkClient = NetworkRequestCreatorMock()
        networkClient.makeRequestBaseURLReturnValue = request

        settings = ConfigFetcherSettingsMock()
        settings.lastFetchDate = Date(timeIntervalSince1970: 0)

        configFetcherOutput = ConfigFetcherOutputMock()
        
        runtimeOptionable = VarioqubRuntimeOptionableMock()
        runtimeOptionable.clientFeatures = clientFeatures

        configFetcher = ConfigFetcher(
            networkClient: networkClient,
            idProvider: idProvider,
            config: internalConfig,
            settings: settings,
            identifiersProvider: identifiersProvider,
            executor: mockExecutor,
            output: configFetcherOutput,
            environmentProvider: envProvider,
            runtimeOptions: runtimeOptionable,
            threadChecker: ThreadChecker()
        )

    }

    func testRequestSerialization() throws {
        configFetcher.fetchExperiments(callback: nil)

        guard let (request, _) = networkClient.makeRequestBaseURLReceivedArguments, let data = request.body else {
            XCTAssert(false)
            return
        }
        let pbRequest = try PBRequest(serializedBytes: data)

        XCTAssertEqual(pbRequest.deviceID, "device")
        XCTAssertEqual(pbRequest.userID, "user")
        XCTAssertEqual(pbRequest.id, "vq_id")
        XCTAssertEqual(
            try getClientFeatures(),
            clientFeatures
        )
        XCTAssertEqual(pbRequest.language, envProvider.language)
        XCTAssertEqual(pbRequest.platform, envProvider.platform)
        XCTAssertEqual(pbRequest.sdkVersion, varioqubVersion.description)
        XCTAssertEqual(pbRequest.version, envProvider.version)
        XCTAssertEqual(pbRequest.versionCode, envProvider.versionCode)
        XCTAssertEqual(pbRequest.osVersion, envProvider.osVersion)
        XCTAssertEqual(pbRequest.sdkAdapterName, internalConfig.repoterName)
        XCTAssertEqual(pbRequest.sdkIDAdapterName, internalConfig.idProviderName)
    }
}

private extension ConfigFetcherRequestTests {
    
    func getClientFeatures() throws -> ClientFeatures {
        guard let (request, _) = networkClient.makeRequestBaseURLReceivedArguments, let data = request.body else {
            XCTAssert(false)
            fatalError()
        }
        let pbRequest = try PBRequest(serializedBytes: data)
        let dict: [String: String] = Dictionary(
            pbRequest.clientFeatures.map { ($0.name, $0.value) },
            uniquingKeysWith: { k1, k2 in
                XCTAssert(false)
                return k2
            }
        )
        return ClientFeatures(dictionary: dict)
    }
    
}
