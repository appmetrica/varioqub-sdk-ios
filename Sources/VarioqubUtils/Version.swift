
public struct Version {
    public typealias Unit = UInt
    
    public var major: Unit
    public var minor: Unit
    public var patch: Unit
    
    public init(major: Unit, minor: Unit, patch: Unit) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    public init?(stringValue: String) {
        let components = stringValue.components(separatedBy: ".")
        guard components.count == 3,
              let major = Unit(components[0]),
              let minor = Unit(components[1]),
              let patch = Unit(components[2])
        else { return nil }
        
        self.major = major
        self.minor = minor
        self.patch = patch
    }
    
    
    
    public static let null = Version(major: 0, minor: 0, patch: 0)
    
    
}

extension Version: Equatable, Hashable, Comparable {
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
    
}

extension Version: CustomStringConvertible {
    
    public var description: String {
        "\(major).\(minor).\(patch)"
    }
}

extension Version: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(stringValue: value)!
    }
    
}
