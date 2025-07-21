
public extension FlagProvider {
    var allKeys: Set<VarioqubFlag> {
        Set(allItems.keys)
    }
}

public extension FlagProvider {
    func get<T: VarioqubInitializableByValue>(for flag: VarioqubFlag, type: T.Type) -> T {
        get(for: flag, type: type, defaultValue: nil)
    }
}

public extension FlagProvider {

    func getString(for flag: VarioqubFlag, defaultValue: String? = nil) -> String {
        get(for: flag, type: String.self, defaultValue: defaultValue)
    }

    func getDouble(for flag: VarioqubFlag, defaultValue: Double? = nil) -> Double {
        get(for: flag, type: Double.self, defaultValue: defaultValue)
    }

    func getInt64(for flag: VarioqubFlag, defaultValue: Int64? = nil) -> Int64 {
        get(for: flag, type: Int64.self, defaultValue: defaultValue)
    }
    
    func getInt(for flag: VarioqubFlag, defaultValue: Int? = nil) -> Int {
        get(for: flag, type: Int.self, defaultValue: defaultValue)
    }

    func getBool(for flag: VarioqubFlag, defaultValue: Bool? = nil) -> Bool {
        get(for: flag, type: Bool.self, defaultValue: defaultValue)
    }

}
