
import Foundation
#if VQ_MODULES
import Varioqub
#endif

func makeVQError(error: Error) -> NSError {
    NSError(domain: error._domain, code: error._code, userInfo: error._userInfo as? [String: Any])
}

func makeVQConfigFetchError(_ error: VarioqubFetchError) -> NSError {
    switch error {
    case .emptyResult:
        return NSError(domain: NSError.CONFIG_FETCH_DOMAIN, code: NSError.CONFIG_FETCH_EMPTY_RESULT_CODE)
    case .nullIdentifiers:
        return NSError(domain: NSError.CONFIG_FETCH_DOMAIN, code: NSError.CONFIG_FETCH_NULL_IDENTIFIER_CODE)
    case .parse:
        return NSError(domain: NSError.CONFIG_FETCH_DOMAIN, code: NSError.CONFIG_FETCH_PARSE_ERROR_CODE)
    case .response:
        return NSError(domain: NSError.CONFIG_FETCH_DOMAIN, code: NSError.CONFIG_FETCH_RESPONSE_ERROR_CODE)
    case .network:
        return NSError(domain: NSError.CONFIG_FETCH_DOMAIN, code: NSError.CONFIG_FETCH_NETWORK_ERROR_CODE)
    case .underlying, .request:
        return NSError(domain: NSError.CONFIG_FETCH_DOMAIN, code: NSError.CONFIG_FETCH_OTHER_CODE)
    }
}
