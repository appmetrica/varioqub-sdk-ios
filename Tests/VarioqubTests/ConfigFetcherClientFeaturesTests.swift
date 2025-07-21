import XCTest
@testable import Varioqub
@testable import VarioqubNetwork
import VarioqubUtils

final class ConfigFetcherClientFeaturesTests: XCTestCase {

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
    var networkClient: SimpleNetworkRequestCreatorMock!
    var settings: ConfigFetcherSettingsMock!
    var identifiersProvider: ConfigIdentifiersProviderMock!
    var configUpdaterMock: ConfigUpdaterInputMock!
    var runtimeOptionable: RuntimeOptionableMock!

    override func setUp() {
        super.setUp()

        identifiersProvider = ConfigIdentifiersProviderMock(id: "vq_id")

        let request = NetworkRequestableMock()
        request.executeReturnValue = request
        request.onCallbackReturnValue = request

        networkClient = SimpleNetworkRequestCreatorMock()
        networkClient.answer = .validAnswer(ServerResponse(body: Data(), statusCode: .success, headers: NetworkHeaders()))

        settings = ConfigFetcherSettingsMock()
        settings.lastFetchDate = Date(timeIntervalSince1970: 0)

        configUpdaterMock = ConfigUpdaterInputMock()
        
        runtimeOptionable = RuntimeOptionableMock()
        runtimeOptionable.clientFeatures = clientFeatures

        configFetcher = ConfigFetcher(networkClient: networkClient,
                idProvider: idProvider,
                config: internalConfig,
                settings: settings,
                identifiersProvider: identifiersProvider,
                executor: mockExecutor,
                output: configUpdaterMock,
                environmentProvider: envProvider,
                runtimeOptions: runtimeOptionable,
                threadChecker: ThreadChecker()
        )

    }
    
    func testClientFeatures() throws {
        configFetcher.fetchExperiments(callback: nil)
        
        XCTAssertEqual(try getClientFeatures(), clientFeatures)
        
        var newClientFeatures = clientFeatures
        newClientFeatures.setFeature("newValue", forKey: "newKey")
        runtimeOptionable.clientFeatures = newClientFeatures
        
        configFetcher.fetchExperiments(callback: nil)
        
        XCTAssertEqual(try getClientFeatures(), newClientFeatures)
    }

}

private extension ConfigFetcherClientFeaturesTests {
    
    func getClientFeatures() throws -> ClientFeatures {
        guard let data = networkClient.receivedRequests.last?.body else {
            XCTAssert(false)
            fatalError()
        }
        let pbRequest = try PBRequest(serializedData: data)
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
