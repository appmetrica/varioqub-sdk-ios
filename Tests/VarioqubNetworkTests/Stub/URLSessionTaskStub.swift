import Foundation

final class URLSessionDataTaskStub: URLSessionDataTask {

    private var _originalRequest: URLRequest?
    private var _currentRequest: URLRequest?

    override public var originalRequest: URLRequest? {
        get { _originalRequest }
        set { _originalRequest = newValue }
    }
    override public var currentRequest: URLRequest? {
        get { _currentRequest }
        set { _currentRequest = newValue }
    }

    override func resume() { }
    override func suspend() { }
    override func cancel() { }
}
