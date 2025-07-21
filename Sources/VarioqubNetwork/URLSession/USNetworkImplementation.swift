import Foundation

// sourcery: AutoMockable
protocol USDataTaskCreator: AnyObject {
    func createDataTask(request: URLRequest, for task: USNetworkTaskRequest) -> URLSessionDataTask
}

final class USNetworkImplementation: NSObject {

    private(set) var session: URLSession!
    private let storage: USNetworkTaskStorage

    init(config: URLSessionConfiguration, storage: USNetworkTaskStorage, operationQueue: OperationQueue) {
        self.storage = storage
        super.init()
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
    }

}

extension USNetworkImplementation: USDataTaskCreator {

    func createDataTask(request: URLRequest, for task: USNetworkTaskRequest) -> URLSessionDataTask {
        session.dataTask(with: request) { [weak task] data, response, error in
            networkLogger.debug("received answer: \(response?.debugDescription ?? "")")
            networkLogger.debug("received error: \(error.debugDescription)")

            task?.handleAnswer(data: data, response: response, error: error)
        }
    }

}

extension USNetworkImplementation: URLSessionDelegate {

}

extension USNetworkImplementation: URLSessionDataDelegate {

}
