import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
extension VQVarioqubInstance {

    public var varioqubId: String? {
        originalInstance.varioqubId
    }

}
