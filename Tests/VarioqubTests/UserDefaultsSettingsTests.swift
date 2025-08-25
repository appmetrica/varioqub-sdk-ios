import XCTest
import VarioqubUtils
@testable import Varioqub

final class UserDefaultsSettingsTests: XCTestCase {
    
    let clientId = "test.123"
    let clientIdPrefix = "test_123"
    
    var userDefaultsMock: UserDefaultMock!
    var settings: UserDefaultsSettings!
    
    let currentVersion: Version = "1.2.3"
    
    func writeDictToMock(dict: [UserDefaultsSettingsKey: Any]) {
        let newValues = dict.mapKeys({ "vq_\(clientIdPrefix)_\($0.rawValue)" }, uniquingKeysWith: { _,_ in fatalError() })
        userDefaultsMock.storage.merge(newValues, uniquingKeysWith: { old, new in new })
    }
    
    func getValueFromMock<T>(key: UserDefaultsSettingsKey, type: T.Type) -> T? {
        let storageKey = "vq_\(clientIdPrefix)_\(key.rawValue)"
        return userDefaultsMock.storage[storageKey] as? T
    }
    
    override func setUp() {
        super.setUp()
        
        self.userDefaultsMock = UserDefaultMock()
        self.settings = UserDefaultsSettings(
            userDefaults: self.userDefaultsMock,
            clientId: clientId,
            currentVersion: currentVersion
        )
    }
    
    func testCheckCorrentPrefix() {
        let correctPrefix = "vq_\(clientIdPrefix)_"
        
        settings.lastEtag = "etag_123"
        settings.isShouldNotifyExperimentChanged = true
        settings.reporterData = Data()
        settings.lastFetchDate = Date()
        settings.storeNetworkDSOv0(Data(), for: NetworkDataKeyDSO.pending.rawValue)
        settings.storeNetworkDSOv0(Data(), for: NetworkDataKeyDSO.active.rawValue)
        
        let d = userDefaultsMock.storage
        d.keys.forEach {
            XCTAssert($0.starts(with: correctPrefix))
        }
    }
    
    func testReadVersionOnlyOnce() {
        writeDictToMock(dict: [.version: currentVersion.description])
        let version = settings.readVersion()
        XCTAssertEqual(version, currentVersion)
        
        userDefaultsMock.storage = [:]
        let newVersion = settings.readVersion()
        XCTAssertEqual(newVersion, currentVersion)
    }

    func testVarioqubVersionShouldReturnNullAtStart() {
        let version = settings.readVersion()
        XCTAssertNil(version)
    }
    
    func testVarioqubVersionShouldReturn1AfterWriting() {
        
        func testWriting(_ writingClosure: () -> ()) {
            userDefaultsMock.storage = [:]
            writingClosure()
            XCTAssertEqual(userDefaultsMock.storage["vq_test_123_version"] as? String, currentVersion.description)
        }
        
        testWriting { settings.lastEtag = "etag_123" }
        testWriting { settings.lastFetchDate = Date() }
        testWriting { settings.reporterData = "reporterData".data(using: .utf8)! }
        testWriting { settings.isShouldNotifyExperimentChanged = true }
        testWriting {
            settings.storeNetworkDSOv0("networkData".data(using: .utf8)!, for: NetworkDataKeyDSO.pending.rawValue)
        }
        
        testWriting { settings.lastEtag = nil }
        testWriting { settings.lastFetchDate = nil }
        testWriting { settings.reporterData = nil }
        testWriting { settings.isShouldNotifyExperimentChanged = false }
        testWriting { settings.storeNetworkDSOv0(nil, for: NetworkDataKeyDSO.pending.rawValue) }
    }
    
    private func doGetTest<T: Equatable>(key: UserDefaultsSettingsKey, value: T, settingsClosure: @autoclosure () -> T?) {
        writeDictToMock(dict: [key: value])
        let settingsValue = settingsClosure()
        XCTAssertEqual(value, settingsValue)
    }
    
    private func doSetTest<T: Equatable>(key: UserDefaultsSettingsKey, value: T, settingsClosure: (T) -> ()) {
        settingsClosure(value)
        let storageValue = getValueFromMock(key: key, type: T.self)
        XCTAssertEqual(value, storageValue)
    }
    
    func testGetVersion() {
        writeDictToMock(dict: [.version: "1.2.3"])
        let version = settings.readVersion()
        XCTAssertEqual(version, Version(major: 1, minor: 2, patch: 3))
    }
    
    func testGetLastFetchDate() {
        doGetTest(key: .lastFetchDate, value: Date(), settingsClosure: settings.lastFetchDate)
    }
    
    func testSetLastFetchDate() {
        doSetTest(key: .lastFetchDate, value: Date()) { settings.lastFetchDate = $0 }
    }
    
    func testGetLastETag() {
        doGetTest(key: .lastETag, value: "etag_123", settingsClosure: settings.lastEtag)
    }
    
    func testSetLastETag() {
        doSetTest(key: .lastETag, value: "etag_123") { settings.lastEtag = $0 }
    }
    
    func testGetShouldUpdateExp() {
        doGetTest(key: .shouldUpdateExpirement, value: true, settingsClosure: settings.isShouldNotifyExperimentChanged)
    }
    
    func testSetShouldUpdateExp() {
        doSetTest(key: .shouldUpdateExpirement, value: true) { settings.isShouldNotifyExperimentChanged = $0 }
    }
    
    func testGetReporterData() {
        doGetTest(key: .reporterData, value: "reporter data".data(using: .utf8)!, settingsClosure: settings.reporterData)
    }
    
    func testSetReporterData() {
        doSetTest(key: .reporterData, value: "reporter data".data(using: .utf8)!) { settings.reporterData = $0 }
    }
    
    func testGetNetworkData() {
        doGetTest(
            key: .networkData(key: "pending"),
            value: "network data".data(using: .utf8)!,
            settingsClosure: settings.loadNetworkDSOv0(for: "pending")
        )
    }
    
    func testSetNetworkData() {
        doSetTest(key: .networkData(key: "pending"), value: "network data".data(using: .utf8)!) {
            settings.storeNetworkDSOv0($0, for: "pending")
        }
    }
    
}
