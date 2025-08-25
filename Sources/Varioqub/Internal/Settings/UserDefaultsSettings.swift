
import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

enum UserDefaultsSettingsKey: Hashable {
    case version
    case lastFetchDate
    case shouldUpdateExpirement
    case lastETag
    case reporterData
    case networkData(key: String)
    case networkDataV110(key: String)

    var rawValue: String {
        switch self {
        case .version: return "version"
        case .lastFetchDate: return "last_fetch_date"
        case .shouldUpdateExpirement: return "should_update_exp"
        case .lastETag: return "last_etag"
        case .reporterData: return "reporter_data"
        case .networkData(let key): return "network_\(key)"
        case .networkDataV110(let key): return "network110_\(key)"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

final class UserDefaultsSettings: VarioqubSettingsProtocol {
    
    let userDefaults: UserDefaultsProtocol
    let clientId: String
    let currentVersion: Version
    
    private var savedVersion: Version?
    
    init(userDefaults: UserDefaultsProtocol, clientId: String, currentVersion: Version) {
        self.userDefaults = userDefaults
        self.clientId = clientId.replacingOccurrences(of: ".", with: "_")
        self.currentVersion = currentVersion
    }
    
    func readVersion() -> Version? {
        if let savedVersion = savedVersion {
            return savedVersion
        }
        
        let versionString = userDefaults.string(forKey: wrappedKey(.version))
        let version = versionString.flatMap { Version(stringValue: $0) }
        self.savedVersion = version
        return version
    }
    
    private var isNeedWriteVersion: Bool {
        let version = readVersion()
        if let version = version, version >= currentVersion {
            return false
        }
        return true
    }
    
    func writeVersion() {
        if isNeedWriteVersion {
            userDefaults.set(currentVersion.description, forKey: wrappedKey(.version))
        }
    }
    
    private func wrappedKey(_ key: UserDefaultsSettingsKey) -> String {
        return "vq_\(clientId)_\(key.rawValue)"
    }

    /// The last date and time when the config was fetched.
    public var lastFetchDate: Date? {
        get { userDefaults.object(forKey: wrappedKey(.lastFetchDate)) as? Date }
        set {
            writeVersion()
            userDefaults.set(newValue, forKey: wrappedKey(.lastFetchDate))
        }
    }

    /// The property that defines if Varioqub should notify the reporter that the experiment changed.
    public var isShouldNotifyExperimentChanged: Bool {
        get { userDefaults.bool(forKey: wrappedKey(.shouldUpdateExpirement)) }
        set {
            writeVersion()
            userDefaults.set(newValue, forKey: wrappedKey(.shouldUpdateExpirement))
        }
    }

    /// The E-Tag header used to detect updates on the server.
    public var lastEtag: String? {
        get { userDefaults.string(forKey: wrappedKey(.lastETag)) }
        set {
            writeVersion()
            userDefaults.set(newValue, forKey: wrappedKey(.lastETag))
        }
    }

    /// The serialized data for the reporter.
    public var reporterData: Data? {
        get { userDefaults.data(forKey: wrappedKey(.reporterData)) }
        set {
            writeVersion()
            userDefaults.set(newValue, forKey: wrappedKey(.reporterData))
        }
    }

    /// Stores the config fetched from the server into the key-value storage identified by the key.
    /// - parameter data: Binary encoded network data.
    /// - parameter key: Network data key.
    public func storeNetworkDSOv0(_ data: Data?, for key: String) {
        writeVersion()
        userDefaults.set(data, forKey: wrappedKey(.networkData(key: key)))
    }

    /// Gets the config by the key.
    /// - parameter key: Network data key.
    /// - returns: The previously saved network data or nil if non-available.
    public func loadNetworkDSOv0(for key: String) -> Data? {
        userDefaults.data(forKey: wrappedKey(.networkData(key: key)))
    }
    
    func storeNetworkModel(_ data: Data?, for key: String) {
        writeVersion()
        userDefaults.set(data, forKey: wrappedKey(.networkDataV110(key: key)))
    }
    
    func loadNetworkModel(for key: String) -> Data? {
        userDefaults.data(forKey: wrappedKey(.networkDataV110(key: key)))
    }
}
