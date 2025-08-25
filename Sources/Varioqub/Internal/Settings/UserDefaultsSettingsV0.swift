import Foundation

enum SettingsKeysV0 {
    static let networkDataPrefix = "vq_"
    static let lastFetchDate = "vq_last_fetch_date"
    static let isShouldUpdateExpirement = "vq_should_update_exp"
    static let lastEtag = "vq_last_etag"
    static let reporterData = "vq_reporter_data"
    static let varioqubVersion = "vq_version"
}

/// UserDefaultsSettings is a default implementation via UserDefaults.
final class UserDefaultsSettingsV0 {

    let userDefaults: UserDefaultsProtocol

    /// Initializes the setting with UserDefaults.
    ///
    /// The user can pass custom UserDefaults to share data with the application extension or for other purposes.
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    
    var varioqubVersion: Int? {
        get { userDefaults.object(forKey: SettingsKeysV0.varioqubVersion) as? Int }
        set { userDefaults.set(newValue, forKey: SettingsKeysV0.varioqubVersion)}
    }

    /// The last date and time when the config was fetched.
    var lastFetchDate: Date? {
        get { userDefaults.object(forKey: SettingsKeysV0.lastFetchDate) as? Date }
        set { userDefaults.set(newValue, forKey: SettingsKeysV0.lastFetchDate) }
    }

    /// The property that defines if Varioqub should notify the reporter that the experiment changed.
    var isShouldNotifyExperimentChanged: Bool {
        get { userDefaults.bool(forKey: SettingsKeysV0.isShouldUpdateExpirement) }
        set { userDefaults.set(newValue, forKey: SettingsKeysV0.isShouldUpdateExpirement) }
    }

    /// The E-Tag header used to detect updates on the server.
    var lastEtag: String? {
        get { userDefaults.string(forKey: SettingsKeysV0.lastEtag) }
        set { userDefaults.set(newValue, forKey: SettingsKeysV0.lastEtag) }
    }

    /// The serialized data for the reporter.
    var reporterData: Data? {
        get { userDefaults.data(forKey: SettingsKeysV0.reporterData) }
        set { userDefaults.set(newValue, forKey: SettingsKeysV0.reporterData) }
    }

    /// Stores the config fetched from the server into the key-value storage identified by the key.
    /// - parameter data: Binary encoded network data.
    /// - parameter key: Network data key.
    func storeNetworkDSOv0(_ data: Data?, for key: String) {
        userDefaults.set(data, forKey: SettingsKeysV0.networkDataPrefix + key)
    }

    /// Gets the config by the key.
    /// - parameter key: Network data key.
    /// - returns: The previously saved network data or nil if non-available.
    func loadNetworkDSOv0(for key: String) -> Data? {
        userDefaults.data(forKey: SettingsKeysV0.networkDataPrefix + key)
    }
}
