import Foundation
@testable import VarioqubNetwork

final class NetworkClientDelayMock: NetworkRequestCreator {

    var makeRequestsArgs: [Request] = []
    var mockedRequestsParams: [(response: NetworkResponse, delay: DispatchTimeInterval)] = []

    func makeRequest(_ request: Request, baseURL: URL) -> NetworkRequestable {
        makeRequestsArgs.append(request)

        let params = mockedRequestsParams.first!
        mockedRequestsParams = Array(mockedRequestsParams.dropFirst())

        let mockedRequest = NetworkRequestDelayMock()
        mockedRequest.delay = params.delay
        mockedRequest.mockResponse = params.response

        return mockedRequest
    }

}

final class NetworkRequestDelayMock: NetworkRequestable {

    var callback: Callback?
    var delay: DispatchTimeInterval!
    var mockResponse: NetworkResponse!

    func execute() -> NetworkRequestable {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.callback?(self.mockResponse)
        }
        return self
    }

    func onCallback(_ callback: @escaping Callback) -> NetworkRequestable {
        self.callback = callback
        return self
    }

    func cancel() {
        callback = nil
    }

}
