
import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
extension VQVarioqubFacade {

    func resource(for key: String) -> VQResource? {
        return mainInstance.resource(for: key)
    }

}
