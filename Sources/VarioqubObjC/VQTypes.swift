
import Foundation

#if VQ_MODULES
import Varioqub
#endif


public typealias VQTestID = Int64
public typealias VQFlag = String

public typealias VQDefaultsCompletion = () -> ()
public typealias VQXmlCompletion = (NSError?) -> ()

public extension NSError {

    @objc
    static let CONFIG_FETCH_DOMAIN = "varioqub.config_fetch.error"

    @objc
    static let CONFIG_FETCH_OTHER_CODE: Int = 0
    @objc
    static let CONFIG_FETCH_EMPTY_RESULT_CODE: Int = 1
    @objc
    static let CONFIG_FETCH_NULL_IDENTIFIER_CODE: Int = 2
    @objc
    static let CONFIG_FETCH_RESPONSE_ERROR_CODE: Int = 3
    @objc
    static let CONFIG_FETCH_NETWORK_ERROR_CODE: Int = 4
    @objc
    static let CONFIG_FETCH_PARSE_ERROR_CODE: Int = 5
}

@objc
public enum VQFetchStatus: Int {
    case success
    case throttled
    case cached
    case error
}

public typealias VQFetchCompletion = (VQFetchStatus, NSError?) -> Void
public typealias VQActivateCompletion = () -> Void
