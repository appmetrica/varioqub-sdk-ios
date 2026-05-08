import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
public extension VQVarioqubInstance {

    var varioqubId: String? {
        originalInstance.varioqubId
    }

}
