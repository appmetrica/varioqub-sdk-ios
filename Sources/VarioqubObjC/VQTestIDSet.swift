
import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public final class VQTestIDSet: NSObject {
    
    private var _set: Set<VQTestID>
    
    init<T: Sequence>(seq: T) where T.Element == VQTestID {
        self._set = .init(seq)
    }
    
    @objc
    public init(set: Set<VQTestID>) {
        self._set = set
    }
    
    @objc
    public init(array: [VQTestID]) {
        self._set = Set(array)
    }
    
    @objc
    public var set: Set<VQTestID> { return _set }
    
}

public extension VQTestIDSet {
    
    convenience init(set: VarioqubTestIDSet) {
        self.init(seq: set.set.map { $0.rawValue })
    }
    
    var testIDSet: VarioqubTestIDSet {
        VarioqubTestIDSet(seq: _set.map { VarioqubTestID(rawValue: $0) })
    }
    
}
