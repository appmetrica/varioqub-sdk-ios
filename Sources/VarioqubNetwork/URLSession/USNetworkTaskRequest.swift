import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

enum USNetworkTaskState {
    case notStarted
    case inProgress
    case finished
}

final class USNetworkTaskRequest {

    let baseURL: URL
    let request: Request
    let executor: AsyncExecutor

    weak var storage: USNetworkTaskStoragable?
    weak var dataTaskCreator: USDataTaskCreator?

    let threadChecker: ThreadChecker

    let callback: UnfairLocker<Callback?> = UnfairLocker(wrappedValue: nil)

    // only state is protected
    // TODO: replace to CAS?
    let state = UnfairLocker<USNetworkTaskState>(wrappedValue: .notStarted)

    // task and cacheKey only available from executor
    var task: URLSessionDataTask?


    init(baseURL: URL,
         request: Request,
         executor: AsyncExecutor,
         storage: USNetworkTaskStoragable,
         dataTaskCreator: USDataTaskCreator,
         threadChecker: ThreadChecker
    ) {
        self.baseURL = baseURL
        self.request = request
        self.executor = executor
        self.storage = storage
        self.dataTaskCreator = dataTaskCreator
        self.threadChecker = threadChecker
    }

}

extension USNetworkTaskRequest: NetworkRequestable {

    @discardableResult
    func execute() -> NetworkRequestable {
        let shouldStart: Bool = state.updateLock {
            let shouldStart = $0 == .notStarted
            if $0 == .notStarted {
                $0 = .inProgress
            }
            return shouldStart
        }

        guard shouldStart else {
            return self
        }

        switch request.makeURLRequest(baseURL: baseURL) {
        case .success(let urlRequest):
            networkLogger.info("start request: \(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? "")")
            executor.execute {
                self.doExecute(request: urlRequest)
            }
        case .failure(let e):
        networkLogger.error("creating request error: \(e)")
            executor.execute {
                self.finishRequest(with: .networkError(e))
            }
        }
        return self
    }

    @discardableResult
    func onCallback(_ callback: @escaping Callback) -> NetworkRequestable {
        self.callback.wrappedValue = callback
        return self
    }

    func cancel() {
        state.inplaceUpdate {
            if $0 == .inProgress {
                $0 = .finished
            }
        }
        executor.execute {
            self.task?.cancel()
            self.task = nil
        }
    }

}

extension USNetworkTaskRequest {

    func doExecute(request: URLRequest) {
        threadChecker.check()
        guard let impl = dataTaskCreator, let storage = storage else {
            return
        }

        self.threadChecker.check()
        let task = impl.createDataTask(request: request, for: self)

        self.task = task

        task.resume()
        networkLogger.debug("request started: \(task.originalRequest.debugDescription)")

        storage.insert(networkTask: self, for: task)
    }

    func doHandleAnswer(data: Data?, response: URLResponse?, error: Error?) {
        threadChecker.check()
        // self.state may be changed by cancel method
        assert({
            let s = state.wrappedValue
            return s == .inProgress || s == .finished
        }())

        if let sr = ServerResponse(data: data, response: response) {
            self.finishRequest(with: sr.statusCode.isOk ? .validAnswer(sr) : .serverError(sr))
        } else {
            if let error = error {
                self.finishRequest(with: .networkError(.connectionError(error: error)))
            } else {
                self.finishRequest(with: .networkError(.serverAnswerError))
            }
        }
    }

    func handleAnswer(data: Data?, response: URLResponse?, error: Error?) {
        executor.execute {
            self.doHandleAnswer(data: data, response: response, error: error)
        }
    }

    func finishRequest(with ans: NetworkResponse) {
        threadChecker.check()
        networkLogger.info("finish request: \(ans)")

        assert(state.wrappedValue != .finished)

        let result: NetworkResponse
        switch ans {
        case .validAnswer(let a):
            assert(a.statusCode.isOk)
            result = ans
        case .serverError(let a):
            //TODO: check etag?
            if a.statusCode == .notModified {
                result = .validAnswer(a)
            } else {
                result = ans
            }
        case .networkError:
            result = ans
        }

        task = nil

        state.wrappedValue = .finished
        executor.execute {
            let callback = self.callback.takeValue()
            callback?(result)
        }
    }

}

extension ServerResponse {

    init?(data: Data?, response: URLResponse?) {
        guard let response = response as? HTTPURLResponse else {
            return nil
        }

        let statusCode = NetworkStatusCode(rawValue: response.statusCode)
        let headers: [String: String] = response.allHeaderFields as? [String: String] ?? [:]

        self.init(body: data, statusCode: statusCode, headers: .init(rawValues: headers))
    }

}

extension Request {

    private func createComponents(baseURL: URL) -> URLComponents? {
        guard let url = URL(string: path, relativeTo: baseURL),
              var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        if !params.isEmpty {
            urlComponent.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value.GETValue)
            }
        }
        return urlComponent
    }

    func makeURLRequest(baseURL: URL) -> Result<URLRequest, NetworkError> {
        guard let urlComponent = createComponents(baseURL: baseURL), let resultURL = urlComponent.url else {
            return .failure(.urlEncodingError)
        }

        var urlRequest = URLRequest(url: resultURL)
        urlRequest.httpMethod = method.stringValue
        if let body = body {
            urlRequest.httpBody = body
        }
        urlRequest.fill(headers: headers)

        return .success(urlRequest)
    }

}
