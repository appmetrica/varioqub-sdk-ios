import Dispatch

extension DispatchQueue: AsyncExecutor, AsyncResultExecutor {

    public func execute(_ closure: @escaping ExecutorClosure) {
        async(execute: closure)
    }

    public func executeAndReturn<T>(_ closure: @escaping ExecutorReturnClosure<T>) rethrows -> T {
        try sync(execute: closure)
    }

}
