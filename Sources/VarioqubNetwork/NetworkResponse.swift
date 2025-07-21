import Foundation

public struct ServerResponse {
    public var body: Data?
    public var statusCode: NetworkStatusCode
    public var headers: NetworkHeaders
}

public enum NetworkError: Error {
    case urlEncodingError
    case serverAnswerError
    case connectionError(error: Error)
}

@frozen
public enum Response<ValidAnswer, ServerErrorAnswer, NetworkError> where NetworkError: Error {
    case validAnswer(ValidAnswer)
    case serverError(ServerErrorAnswer)
    case networkError(NetworkError)
}

public typealias NetworkResponse = Response<ServerResponse, ServerResponse, NetworkError>

public extension Response {

    func map<T>(_ closure: (ValidAnswer) throws -> T) rethrows -> Response<T, ServerErrorAnswer, NetworkError> {
        switch self {
        case .validAnswer(let a): return .validAnswer(try closure(a))
        case .serverError(let s): return .serverError(s)
        case .networkError(let n): return .networkError(n)
        }
    }

    func flatMap<T>(_ closure: (ValidAnswer) throws -> Response<T, ServerErrorAnswer, NetworkError>)
            rethrows -> Response<T, ServerErrorAnswer, NetworkError> {
        switch self {
        case .validAnswer(let a): return try closure(a)
        case .serverError(let s): return .serverError(s)
        case .networkError(let n): return .networkError(n)
        }
    }

    func mapServerError<T>(_ closure: (ServerErrorAnswer) throws -> T) rethrows -> Response<ValidAnswer, T, NetworkError> {
        switch self {
        case .validAnswer(let a): return .validAnswer(a)
        case .serverError(let s): return .serverError(try closure(s))
        case .networkError(let n): return .networkError(n)
        }
    }

    func flatMapServerError<T>(_ closure: (ServerErrorAnswer) throws -> Response<ValidAnswer, T, NetworkError>)
            rethrows -> Response<ValidAnswer, T, NetworkError> {
        switch self {
        case .validAnswer(let a): return .validAnswer(a)
        case .serverError(let s): return try closure(s)
        case .networkError(let n): return .networkError(n)
        }
    }

    func mapNetworkError<E>(_ closure: (NetworkError) throws -> E) rethrows -> Response<ValidAnswer, ServerErrorAnswer, E> where E: Error {
        switch self {
        case .validAnswer(let a): return .validAnswer(a)
        case .serverError(let s): return .serverError(s)
        case .networkError(let n): return .networkError(try closure(n))
        }
    }

}

public extension Response where ServerErrorAnswer == NetworkError {

    var result: Result<ValidAnswer, ServerErrorAnswer>  {
        switch self {
        case .validAnswer(let a): return .success(a)
        case .serverError(let s): return .failure(s)
        case .networkError(let n): return .failure(n)
        }
    }

}
