import VarioqubUtils

final class MockExecutor: AsyncExecutor {
    func execute(_ closure: @escaping ExecutorClosure) {
        closure()
    }
}
