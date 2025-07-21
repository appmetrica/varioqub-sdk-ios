import Foundation
@testable import VarioqubNetwork

final class USDataTaskCreatorStub: USDataTaskCreator {
    func createDataTask(request: URLRequest, for task: USNetworkTaskRequest) -> URLSessionDataTask {
        let task = URLSessionDataTaskStub()
        task.originalRequest = request
        task.currentRequest = request
        return task
    }
}
