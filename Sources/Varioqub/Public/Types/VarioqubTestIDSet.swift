
/// The VarioqubTestIDSet struct that represents a set of VarioqubTestIDs.
public struct VarioqubTestIDSet {

    /// The raw value of the VarioqubTestID set.
    public var set: Set<VarioqubTestID>

    /// Initializes an empty set.
    public init() {
        set = .init()
    }

    /// Initializes the class with a set of the ``VarioqubTestID`` values.
    /// - parameter testIdSet: The set of the ``VarioqubTestID`` values.
    public init(testIdSet: Set<VarioqubTestID>) {
        self.set = testIdSet
    }

    /// Initializes the class with a sequence of the ``VarioqubTestID`` values.
    /// - parameter seq: The sequence of the ``VarioqubTestID`` values.
    public init<T: Sequence>(seq: T) where T.Element == VarioqubTestID {
        self.set = .init(seq)
    }

    mutating func append(_ testId: VarioqubTestID) {
        set.insert(testId)
    }

    mutating func restrict<S: Sequence>(_ newSet: S) where S.Element == VarioqubTestID {
        set.formIntersection(newSet)
    }
}
