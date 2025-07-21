import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

public final class USNetworkRequestCreator {
    let executor: AsyncExecutor
    let operationQueue: OperationQueue
    let threadChecker: ThreadChecker

    private(set) var storage: USNetworkTaskStorage
    private(set) var impl: USNetworkImplementation

    public init(config: URLSessionConfiguration, queue: DispatchQueue) {
        let storage = USNetworkTaskStorage()
        let operationQueue = OperationQueue()
        operationQueue.underlyingQueue = queue
        let impl = USNetworkImplementation(config: config, storage: storage, operationQueue: operationQueue)

        self.storage = storage
        self.impl = impl
        self.operationQueue = operationQueue
        self.threadChecker = ThreadChecker(queue: queue)

        // now let it share, varioqub makes requests very rarely
        executor = queue
    }
}

extension USNetworkRequestCreator: NetworkRequestCreator {

    public func makeRequest(_ request: Request, baseURL: URL) -> NetworkRequestable {
        USNetworkTaskRequest(
                baseURL: baseURL,
                request: request,
                executor: executor,
                storage: storage,
                dataTaskCreator: impl,
                threadChecker: threadChecker
        )
    }

}

public extension URLSessionConfiguration {

    static var varioqubDefault: URLSessionConfiguration {
        let result = self.default
        result.timeoutIntervalForRequest = 10
        result.timeoutIntervalForResource = 15
        return result
    }

}
