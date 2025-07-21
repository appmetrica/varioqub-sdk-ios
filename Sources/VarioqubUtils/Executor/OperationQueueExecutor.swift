import Foundation

extension OperationQueue: AsyncExecutor {

    public func execute(_ closure: @escaping ExecutorClosure) {
        addOperation(closure)
    }

}
