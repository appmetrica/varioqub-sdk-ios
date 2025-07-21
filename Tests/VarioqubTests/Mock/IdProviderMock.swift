@testable import Varioqub

struct ConfigIdProviderMock: VarioqubIdProvider {
    
    var deviceId: String
    var userId: String

    func fetchIdentifiers(completion: @escaping Completion) {
        completion(.success(.init(deviceId: deviceId, userId: userId)))
    }
    
    var varioqubName: String {
        return "Mock"
    }
}
