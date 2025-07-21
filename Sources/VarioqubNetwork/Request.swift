import Foundation

public protocol GetParameterConvertible {
    var GETValue: String { get }
}

public enum RequestMethod: String, Equatable {
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
}

public struct Request {
    public var path: String
    public var method: RequestMethod
    public var params: [String: GetParameterConvertible]
    public var body: Data?
    public var headers: NetworkHeaders

    public static func get(path: String, params: [String: GetParameterConvertible] = [:]) -> Request {
        Request(path: path,
                method: .GET,
                params: params,
                body: nil,
                headers: .init()
        )
    }

    public static func post(path: String, body: Data? = nil, params: [String: GetParameterConvertible] = [:]) -> Request {
        Request(path: path,
                method: .POST,
                params: params,
                body: body,
                headers: .init()
        )
    }

    public mutating func addHeader(_ value: String, for key: String) {
        headers.setHeader(name: key, value: value)
    }

    public mutating func removeHeader(for key: String) {
        headers.setHeader(name: key, value: nil)
    }

    public func withHeader(_ value: String, for key: String) -> Request {
        var result = self
        result.headers.setHeader(name: key, value: value)
        return result
    }

    public func withContentType(_ contentType: String) -> Request {
        return withHeader(contentType, for: "Content-Type")
    }

    public func withIfNoneMatch(_ etag: String?) -> Request {
        guard let etag = etag, !etag.isEmpty else { return self }
        return withHeader(etag, for: "If-None-Match")
    }

}

extension RequestMethod {

    var stringValue: String {
        rawValue
    }

}

extension String: GetParameterConvertible {
    public var GETValue: String {
        self
    }
}
