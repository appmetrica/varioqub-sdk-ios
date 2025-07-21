import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
public extension VQVarioqubInstance {

    var sendEventOnChangeConfig: Bool {
        get { originalInstance.sendEventOnChangeConfig }
        set { originalInstance.sendEventOnChangeConfig = newValue }
    }
    
    var clientFeatures: VQClientFeatures {
        get { VQClientFeatures(clientFeatures: originalInstance.clientFeatures) }
        set { originalInstance.clientFeatures = newValue.clientFeatures }
    }

}
