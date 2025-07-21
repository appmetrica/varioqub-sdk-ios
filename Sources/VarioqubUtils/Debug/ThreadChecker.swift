
import Dispatch

#if VQ_DISABLE_THREAD_CHECKER
public final class ThreadChecker {
    init() { }

    public init(queue: DispatchQueue?) {
    }

    @inlinable
    public func check() {
    }
}
#else
public final class ThreadChecker {

    @usableFromInline
    let queue: DispatchQueue?

    public init() {
        queue = nil
    }

    public init(queue: DispatchQueue?) {
        self.queue = queue
    }

    @inlinable
    public func check() {
        if let queue = queue {
            dispatchPrecondition(condition: .onQueue(queue))
        }
    }
}
#endif
