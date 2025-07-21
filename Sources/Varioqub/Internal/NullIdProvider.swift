
final class NullIdProvider: VarioqubIdProvider {
    func fetchIdentifiers(completion: @escaping Completion) {
        completion(.success(.empty))
    }
    
    var varioqubName: String { return varioqubNullIdProviderName }
}
