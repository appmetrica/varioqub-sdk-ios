public protocol Optionable {
    associatedtype Wrapped
    init(wrapped: Wrapped?)
    var wrapped: Wrapped? { get }
}

extension Optional: Optionable {
    public typealias Wrapped = Wrapped
    public init(wrapped: Wrapped?) { self = wrapped }
    public var wrapped: Wrapped? { self }
}
