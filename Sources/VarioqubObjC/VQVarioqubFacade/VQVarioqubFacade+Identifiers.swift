import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
extension VQVarioqubFacade {

    public var varioqubId: String? {
        mainInstance.varioqubId
    }

}
