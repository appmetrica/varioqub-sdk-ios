import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubFacade {

    var varioqubId: String? {
        mainInstance.varioqubId
    }

}
