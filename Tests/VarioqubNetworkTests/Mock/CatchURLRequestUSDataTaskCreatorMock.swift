import Foundation
@testable import VarioqubNetwork

final class CatchURLRequestUSDataTaskCreatorMock: USDataTaskCreator {

    var catchedURLRequest: URLRequest?

    func createDataTask(request: URLRequest, for task: USNetworkTaskRequest) -> URLSessionDataTask {
        catchedURLRequest = request
        return URLSessionDataTaskStub()
    }

}
