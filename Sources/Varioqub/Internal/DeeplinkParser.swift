import Foundation

enum DeeplinkParser {
    
    static func parse(url: URL) -> VarioqubParameters {
        guard let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return VarioqubParameters() }
        let pairs: [(String, String)] = urlComponent.queryItems?.map { ($0.name, $0.value ?? "") } ?? []
        return VarioqubParameters(dictionary: Dictionary(pairs, uniquingKeysWith: { $1 }))
    }
    
}
