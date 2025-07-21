
import Foundation
import XCTest
@testable import Varioqub

final class SettingsMigratorTests: XCTestCase {
    
    let clientId = "vq_test.123"
    let clientIdPrefix = "vq_test_123"
    
    var oldMock: UserDefaultMock!
    var newMock: UserDefaultMock!
    
    var oldSettings: UserDefaultsSettingsV0!
    var newSettings: UserDefaultsSettings!
    
    var migrator: SettingsMigrator!
    
    func writeDictToNewMock(dict: [UserDefaultsSettingsKey: Any]) {
        let newValues = dict.mapKeys({ "vq_\(clientIdPrefix)_\($0.rawValue)" }, uniquingKeysWith: { _,_ in fatalError() })
        newMock.storage.merge(newValues, uniquingKeysWith: { old, new in new })
    }
    
    func getValueFromNewMock<T>(key: UserDefaultsSettingsKey, type: T.Type) -> T? {
        let storageKey = "vq_\(clientIdPrefix)_\(key.rawValue)"
        return newMock.storage[storageKey] as? T
    }
    
    func writeDictToOldMock(dict: [String: Any]) {
        oldMock.storage.merge(dict, uniquingKeysWith: { old, new in new })
    }
    
    func getValueFromOldMock<T>(key: String, type: T.Type) -> T? {
        return oldMock.storage[key] as? T
    }
    
    override func setUp() {
        super.setUp()
        
        oldMock = UserDefaultMock()
        newMock = UserDefaultMock()
        
        oldSettings = UserDefaultsSettingsV0(userDefaults: oldMock)
        newSettings = UserDefaultsSettings(userDefaults: newMock, clientId: clientId, currentVersion: varioqubVersion)
        
        migrator = SettingsMigrator(input: oldSettings, output: newSettings)
    }
    
    func testMustNotMigrateIfVersionSet() {
        writeDictToNewMock(dict: [.version: varioqubVersion.description])
        writeDictToOldMock(dict: [
            SettingsKeysV0.lastEtag: "etag",
            SettingsKeysV0.lastFetchDate: Date(),
            SettingsKeysV0.reporterData: "reporter".data(using: .utf8)!,
            SettingsKeysV0.networkDataPrefix + "pending": "network".data(using: .utf8)!
        ])
        
        migrator.migrateIfNeed()
        XCTAssertEqual(getValueFromNewMock(key: .version, type: String.self), varioqubVersion.description)
        XCTAssertEqual(newMock.storage.count, 1)
    }
    
    func testMigrate() {
        let etagValue = "etag"
        let fetchDateValue = Date()
        let reporterDataValue = "reporter".data(using: .utf8)!
        let pendingDataValue = "pending network".data(using: .utf8)!
        let activeDataValue = "active network".data(using: .utf8)!
        let shouldUpdateExpValue = true
        writeDictToOldMock(dict: [
            SettingsKeysV0.lastEtag: etagValue,
            SettingsKeysV0.lastFetchDate: fetchDateValue,
            SettingsKeysV0.reporterData: reporterDataValue,
            SettingsKeysV0.networkDataPrefix + "pending": pendingDataValue,
            SettingsKeysV0.networkDataPrefix + "active": activeDataValue,
            SettingsKeysV0.isShouldUpdateExpirement: shouldUpdateExpValue
        ])
        
        migrator.migrateIfNeed()
        
        XCTAssertEqual(getValueFromNewMock(key: .version, type: String.self), varioqubVersion.description)
        XCTAssertEqual(getValueFromNewMock(key: .lastETag, type: String.self), etagValue)
        XCTAssertEqual(getValueFromNewMock(key: .lastFetchDate, type: Date.self), fetchDateValue)
        XCTAssertEqual(getValueFromNewMock(key: .reporterData, type: Data.self), reporterDataValue)
        XCTAssertEqual(getValueFromNewMock(key: .shouldUpdateExpirement, type: Bool.self), shouldUpdateExpValue)
        XCTAssertEqual(getValueFromNewMock(key: .networkData(key: NetworkDataKey.pending.rawValue), type: Data.self), pendingDataValue)
        XCTAssertEqual(getValueFromNewMock(key: .networkData(key: NetworkDataKey.active.rawValue), type: Data.self), activeDataValue)
        XCTAssertEqual(newMock.storage.count, 7)
    }
    
}
