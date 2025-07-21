import XCTest
@testable import Varioqub


final class UserDefaultsSettingsV0Tests: XCTestCase {
    
    var userDefaultsMock: UserDefaultMock!
    var settings: UserDefaultsSettingsV0!
    
    let currentVersion = 1
    
    func writeDictToMock(dict: [String: Any]) {
        userDefaultsMock.storage.merge(dict, uniquingKeysWith: { old, new in new })
    }
    
    func getValueFromMock<T>(key: String, type: T.Type) -> T? {
        return userDefaultsMock.storage[key] as? T
    }
    
    override func setUp() {
        super.setUp()
        
        self.userDefaultsMock = UserDefaultMock()
        self.settings = UserDefaultsSettingsV0(userDefaults: self.userDefaultsMock)
    }
    
    private func doGetTest<T: Equatable>(key: String, value: T, settingsClosure: @autoclosure () -> T?) {
        writeDictToMock(dict: [key: value])
        let settingsValue = settingsClosure()
        XCTAssertEqual(value, settingsValue)
    }
    
    private func doSetTest<T: Equatable>(key: String, value: T, settingsClosure: (T) -> ()) {
        settingsClosure(value)
        let storageValue = getValueFromMock(key: key, type: T.self)
        XCTAssertEqual(value, storageValue)
    }
    
    func testGetLastFetchDate() {
        doGetTest(key: SettingsKeysV0.lastFetchDate, value: Date(), settingsClosure: settings.lastFetchDate)
    }
    
    func testSetLastFetchDate() {
        doSetTest(key: SettingsKeysV0.lastFetchDate, value: Date()) { settings.lastFetchDate = $0 }
    }
    
    func testGetLastETag() {
        doGetTest(key: SettingsKeysV0.lastEtag, value: "etag_123", settingsClosure: settings.lastEtag)
    }
    
    func testSetLastETag() {
        doSetTest(key: SettingsKeysV0.lastEtag, value: "etag_123") { settings.lastEtag = $0 }
    }
    
    func testGetShouldUpdateExp() {
        doGetTest(
            key: SettingsKeysV0.isShouldUpdateExpirement,
            value: true,
            settingsClosure: settings.isShouldNotifyExperimentChanged
        )
    }
    
    func testSetShouldUpdateExp() {
        doSetTest(
            key: SettingsKeysV0.isShouldUpdateExpirement,
            value: true
        ) {
            settings.isShouldNotifyExperimentChanged = $0
        }
    }
    
    func testGetReporterData() {
        doGetTest(
            key: SettingsKeysV0.reporterData,
            value: "reporter data".data(using: .utf8)!,
            settingsClosure: settings.reporterData
        )
    }
    
    func testSetReporterData() {
        doSetTest(
            key: SettingsKeysV0.reporterData,
            value: "reporter data".data(using: .utf8)!
        ) {
            settings.reporterData = $0
        }
    }
    
    func testGetNetworkData() {
        doGetTest(
            key: SettingsKeysV0.networkDataPrefix + "pending",
            value: "network data".data(using: .utf8)!,
            settingsClosure: settings.loadNetworkData(for: "pending")
        )
    }
    
    func testSetNetworkData() {
        doSetTest(
            key: SettingsKeysV0.networkDataPrefix + "pending",
            value: "network data".data(using: .utf8)!
        ) {
            settings.storeNetworkData($0, for: "pending")
        }
    }
    
}
