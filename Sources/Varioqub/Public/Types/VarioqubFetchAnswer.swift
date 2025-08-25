/// The enum that represents the fetch result.
public enum VarioqubFetchAnswer {
    /// Varioqub config is fetched successfully.
    case success

    /// Varioqub doesn't sent the request due to the timeout from previous request that is too small.
    ///
    /// Sets up the ``VarioqubConfig/fetchThrottle`` throttle.
    case throttled

    /// Varioqub performed a request but nothing was changed.
    case cached

    /// Varioqub performed a request but it failed.
    ///
    /// See error details: ``ConfigFetcherError``.
    case error(VarioqubFetchError)

    /// Returns true if the request is ``VarioqubFetchAnswer/success``.
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        default: return false
        }
    }

    /// Returns true if the request is ``VarioqubFetchAnswer/throttled``.
    public var isThrottled: Bool {
        switch self {
        case .throttled: return true
        default: return false
        }
    }

    /// Returns true if the request is ``VarioqubFetchAnswer/cached``.
    public var isCached: Bool {
        switch self {
        case .cached: return true
        default: return false
        }
    }

    /// Returns true if the request is ``VarioqubFetchAnswer/error(_:)``.
    public var isError: Bool {
        switch self {
        case .error: return true
        default: return false
        }
    }
}

typealias ConfigFetcherAnswer = VarioqubFetchAnswer

/// Varioqub error that occurs when it tries to fetch the config.
public enum VarioqubFetchError: Error {
    /// The server returns an empty response.
    case emptyResult

    /// ``VarioqubIdProvider/fetchIdentifiers(completion:)`` returns an error.
    case nullIdentifiers

    /// The request data can't be serialized into binary data.
    case request

    /// The server returns an error.
    /// - parameter _: The underlying error that causes the server error.
    case response(Error)

    /// The response can't be deserialized.
    /// - parameter _: The underlying error that causes the parse error.
    case parse(Error)

    /// The network error with details.
    /// - parameter _: The underlying error that causes the network error.
    case network(Error)

    /// Some other error with details.
    /// - parameter _: The underlying error.
    case underlying(Error)
}

 typealias ConfigFetcherError = VarioqubFetchError
