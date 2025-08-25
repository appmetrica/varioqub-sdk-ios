
import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
extension VQVarioqubInstance {

    func resource(for key: String) -> VQResource? {
        let originalResource = originalInstance.resource(for: VarioqubResourceKey(rawValue: key))
        return originalResource.map { VQResource(type: $0.type, value: $0.value) }
    }

}
