import Foundation

// sourcery: AutoMockable
public protocol NetworkRequestable: AnyObject {
    typealias Callback = (NetworkResponse) -> Void

    @discardableResult
    func execute() -> NetworkRequestable

    @discardableResult
    func onCallback(_ callback: @escaping Callback) -> NetworkRequestable
    func cancel()
}

// sourcery: AutoMockable
public protocol NetworkRequestCreator {
    func makeRequest(_ request: Request, baseURL: URL) -> NetworkRequestable
}
