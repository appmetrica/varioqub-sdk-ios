
import Foundation
#if VQ_MODULES
import Varioqub
#endif

final class VQIdProviderProxy: VarioqubIdProvider {
    
    let objProvider: VQIdProvider

    init(objProvider: VQIdProvider) {
        self.objProvider = objProvider
    }

    func fetchIdentifiers(completion: @escaping Completion) {
        objProvider.fetchIdentifiers {
            if let userId = $0, let deviceId = $1 {
                completion(.success(.init(deviceId: deviceId, userId: userId)))
            } else if let error = $2 {
                completion(.failure(.underlying(error: error)))
            } else {
                completion(.failure(.general))
            }
        }
    }
    
    var varioqubName: String {
        return objProvider.varioqubName
    }
    
}
