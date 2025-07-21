import XCTest
@testable import Varioqub

class PersistentStorageTests: XCTestCase {

    var storage: NetworkDataStorable!

    override func setUp() {
        super.setUp()

    }

    func recreateSettings() {

    }
    
    func generateRandomNetworkDataDTO() -> NetworkDataDTO {
        let flags: [NetworkDataDTO.Value] = [
            .init(flag: "feature_\(arc4random())", value: UUID().uuidString, testId: Int64(arc4random())),
            .init(flag: "feature_\(arc4random())", value: UUID().uuidString, testId: Int64(arc4random())),
            .init(flag: "feature_\(arc4random())", value: UUID().uuidString, testId: Int64(arc4random())),
        ]

        let data = NetworkDataDTO(
            id: "vq_id_\(arc4random())",
            experimentId: "exp_id_\(arc4random())",
            flags: flags
        )
        
        return data
    }

    func testSaveLoad() {
        // disable test for PersistentStorageTests class
        // only subclass allowed to perform this test
        guard type(of: self) != PersistentStorageTests.self else { return }

        
        let pendingData = generateRandomNetworkDataDTO()
        let activeData = generateRandomNetworkDataDTO()
        
        storage.saveNetworkData(pendingData, for: .pending)
        storage.saveNetworkData(activeData, for: .active)
        
        recreateSettings()
        let loadedPendingData = storage.loadNetworkData(for: .pending)
        let loadedActiveData = storage.loadNetworkData(for: .active)

        XCTAssertEqual(pendingData, loadedPendingData)
        XCTAssertEqual(activeData, loadedActiveData)
    }

}

final class UserDefaultStorageTests: PersistentStorageTests {

    var settings: UserDefaultsSettings!

    override func setUp() {
        super.setUp()

        recreateSettings()
    }

    override func recreateSettings() {
        settings = UserDefaultsSettings(
            userDefaults: UserDefaults.standard,
            clientId: "appmetrica.12345",
            currentVersion: varioqubVersion
        )
        storage = VarioqubSettingsProxy(realSettings: settings)
    }
}
