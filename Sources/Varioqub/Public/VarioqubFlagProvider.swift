/// The protocol that defines a set of methods and properties for retrieving flag values and their corresponding config values.
public protocol VarioqubFlagProvider {

    /// Returns data for the flag.
    /// - parameter flag: The flag.
    /// - parameter type: The type of the return value.
    /// - parameter defaultValue: The function that returns the default value if no value available for this flag could be found.
    /// - returns: The specific type value.
    func get<T: VarioqubInitializableByValue>(for flag: VarioqubFlag, type: T.Type, defaultValue: T?) -> T

    /// Returns data for the flag.
    /// - parameter flag: The flag name.
    /// - returns: The value for the flag, or value with ``VarioqubConfigValue/Source/defaultValue`` if nothing found.
    func getValue(for flag: VarioqubFlag) -> VarioqubConfigValue

    /// All active flags with values.
    var allItems: [VarioqubFlag: VarioqubConfigValue] { get }

    /// All active keys.
    var allKeys: Set<VarioqubFlag> { get }
}

public typealias FlagProvider = VarioqubFlagProvider
