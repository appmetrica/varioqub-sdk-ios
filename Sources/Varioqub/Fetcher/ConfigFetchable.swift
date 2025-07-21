import Foundation

enum ConfigFetcherResponseError: Error {
    case emptyBody
    case serverError
    case networkError(Error)
}

typealias ConfigFetchCallback = (ConfigFetcherAnswer) -> Void

// sourcery: AutoMockable
protocol ConfigFetchable: AnyObject {
    func fetchExperiments(callback: ConfigFetchCallback?)
}

// sourcery: AutoMockable
protocol ConfigFetcherSettings: AnyObject {
    var lastFetchDate: Date { get set }
    var etag: String? { get set }
}

protocol VarioqubIdentifiersProvider {
    var varioqubIdentifier: String? { get }
}
