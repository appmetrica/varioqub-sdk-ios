import Foundation

/// VarioqubSettingsProtocol is a protocol to provide a persistent storage that allows managing and storing settings related to Varioqub. You can implement it if you want to use a custom storage.
// sourcery: AutoMockable
public protocol VarioqubSettingsProtocol: AnyObject {
    
    /// The last date and time when the config was fetched.
    var lastFetchDate: Date? { get set }

    /// The property that defines if Varioqub should notify the reporter that the experiment changed.
    var isShouldNotifyExperimentChanged: Bool { get set }

    /// The E-Tag header used to detect updates on the server.
    var lastEtag: String? { get set }

    /// The serialized data for the reporter.
    var reporterData: Data? { get set }

    func storeNetworkModel(_ data: Data?, for key: String)
    
    func loadNetworkModel(for key: String) -> Data?
    
    /// Stores the config fetched from the server into the key-value storage identified by the key.
    func storeNetworkDSOv0(_ data: Data?, for key: String)

    /// Gets the config by the key.
    func loadNetworkDSOv0(for key: String) -> Data?
}

// sourcery: AutoMockable
public protocol VarioqubSettingsFactory {
    func createSettings(for clientId: String) -> VarioqubSettingsProtocol
}

public final class UserDefaultsSettingsFactory: VarioqubSettingsFactory {
    let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    public func createSettings(for clientId: String) -> any VarioqubSettingsProtocol {
        return UserDefaultsSettings(userDefaults: userDefaults, clientId: clientId, currentVersion: varioqubVersion)
    }
}
