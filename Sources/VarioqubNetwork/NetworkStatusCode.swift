
public struct NetworkStatusCode: RawRepresentable {
    public var rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public extension NetworkStatusCode {
    var isOk: Bool {
        (200..<300).contains(rawValue)
    }

    static let success = NetworkStatusCode(rawValue: 200)
    static let notModified = NetworkStatusCode(rawValue: 304)
}
