import Foundation
@testable import VarioqubNetwork

final class SimpleNetworkRequestCreatorMock: NetworkRequestCreator {
    
    var answer: NetworkResponse?
    
    var receivedRequests: [Request] = []
    
    func makeRequest(_ request: Request, baseURL: URL) -> NetworkRequestable {
        receivedRequests.append(request)
        return SimpleNetworkRequestableMock(request: request, baseURL: baseURL, answer: answer)
    }
    
    
}

private final class SimpleNetworkRequestableMock: NetworkRequestable {
    
    let request: Request
    let baseURL: URL
    
    var answer: NetworkResponse?
    
    private var callback: Callback?
    
    init(request: Request, baseURL: URL, answer: NetworkResponse?) {
        self.request = request
        self.baseURL = baseURL
        self.answer = answer
    }
    
    
    func execute() -> NetworkRequestable {
        if let callback = callback, let answer = answer {
            callback(answer)
        }
        return self
    }
    
    func onCallback(_ callback: @escaping Callback) -> NetworkRequestable {
        self.callback = callback
        return self
    }
    
    func cancel() {
        
    }
    
}
