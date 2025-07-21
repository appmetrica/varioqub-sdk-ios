public typealias ExecutorClosure = () -> Void
public typealias ExecutorReturnClosure<T> = () throws -> T

public protocol AsyncExecutor {
    func execute(_ closure: @escaping ExecutorClosure)
}

public protocol AsyncResultExecutor {
    func executeAndReturn<T>(_ closure: @escaping ExecutorReturnClosure<T>) rethrows -> T
}

public typealias CombinedAsyncExecutor = AsyncExecutor & AsyncResultExecutor
