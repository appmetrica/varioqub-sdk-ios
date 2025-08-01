
#if VQ_MODULES
import VarioqubUtils
#endif

final class SettingsMigrator: VariqubLoadable {

    private let input: UserDefaultsSettingsV0
    private let output: UserDefaultsSettings

    static let migrationVersion: Version = Version(major: 0, minor: 8, patch: 0)
    
    init(input: UserDefaultsSettingsV0, output: UserDefaultsSettings) {
        self.input = input
        self.output = output
    }
    
    private func copyNetworkData(key: NetworkDataKey) {
        let data = input.loadNetworkData(for: key.rawValue)
        output.storeNetworkData(data, for: key.rawValue)
    }
    
    private func clearInputV1() {
        input.lastEtag = nil
        input.lastFetchDate = nil
        input.reporterData = nil
        input.storeNetworkData(nil, for: NetworkDataKey.pending.rawValue)
        input.storeNetworkData(nil, for: NetworkDataKey.active.rawValue)
    }
    
    private func migrateToVer080() {
        output.lastFetchDate = input.lastFetchDate
        output.isShouldNotifyExperimentChanged = input.isShouldNotifyExperimentChanged
        output.lastEtag = input.lastEtag
        output.reporterData = input.reporterData
        
        copyNetworkData(key: .pending)
        copyNetworkData(key: .active)
        
        clearInputV1()
    }
    
    private func isMigrationNeeded(from version: Version?) -> Bool {
        if let version = version, version >= Self.migrationVersion {
            return false
        } else {
            return true
        }
    }
    
    func migrateIfNeed() {
        let version = output.readVersion()
        
        if isMigrationNeeded(from: version) {
            migrateToVer080()
        }
        
    }
    
    func load() {
        migrateIfNeed()
    }
    
}
