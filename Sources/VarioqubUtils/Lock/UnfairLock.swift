import Darwin

public final class UnfairLock {

    @usableFromInline
    var lock = os_unfair_lock()

    public init() {
    }

    @inlinable
    public func lock<T>(_ closure: () throws -> T) rethrows -> T {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        return try closure()
    }

}

@propertyWrapper
public final class UnfairLocker<Value> {

    @usableFromInline
    var lock = os_unfair_lock()

    @usableFromInline
    var value: Value

    public init(wrappedValue value: Value) {
        self.value = value
    }

    @inlinable
    @discardableResult
    public func updateLock<T>(_ closure: (inout Value) throws -> T) rethrows -> T {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }

        return try closure(&value)
    }

    @inlinable
    @discardableResult
    public func update(_ closure: (Value) throws -> Value) rethrows -> Value {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }

        let newValue = try closure(value)
        value = newValue
        return newValue
    }

    @inlinable
    @discardableResult
    public func inplaceUpdate(_ closure: (inout Value) throws -> Void) rethrows -> Value {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }

        try closure(&value)
        return value
    }

    @inlinable
    public var wrappedValue: Value {
        get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return value
        }
        set {
            update { _ in newValue }
        }
    }
}

public extension UnfairLocker where Value: Optionable {

    @inlinable
    func takeValue() -> Value {
        os_unfair_lock_lock(&lock)
        defer {
            value = .init(wrapped: nil)
            os_unfair_lock_unlock(&lock)
        }

        return value
    }

}
