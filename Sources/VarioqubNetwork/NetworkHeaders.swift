import Foundation

private enum Headers {
    static let etag = "Etag"
    static let ifNoneMatch = "If-None-Match"
}

public struct NetworkHeaders {
    var rawValues: [String: String]

    public init(rawValues: [String: String] = [:]) {
        self.rawValues = rawValues
    }

    mutating func setHeader(name: String, value: String?) {
        rawValues[name] = value
    }
}

public extension NetworkHeaders {

    var etag: String? {
        rawValues[Headers.etag]
    }

    mutating func setIfNoneMatch(_ etag: String) {
        rawValues[Headers.ifNoneMatch] = etag
    }

}

extension URLRequest {

    mutating func fill(headers: NetworkHeaders) {
        headers.rawValues.forEach { (k, v) in
            setValue(v, forHTTPHeaderField: k)
        }
    }

}

