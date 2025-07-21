
import Foundation
#if VQ_MODULES
import Varioqub
import VarioqubUtils
#endif


@objc
public final class VQVarioqubFacade: NSObject {

    let oriVQ: VarioqubFacade = .shared

    @objc(sharedVarioqub)
    public static let shared = VQVarioqubFacade()
    
    private override init() {
        super.init()
    }

    var mainInstance: VQVarioqubInstance = .null
}
