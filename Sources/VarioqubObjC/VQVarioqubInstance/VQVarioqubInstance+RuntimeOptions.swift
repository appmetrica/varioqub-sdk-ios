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
    
    var clientFeatures: VQVarioqubClientFeatures {
        get { VQVarioqubClientFeatures(clientFeatures: originalInstance.clientFeatures) }
        set { originalInstance.clientFeatures = newValue.clientFeatures }
    }
    
    var runtimeParams: VQVarioqubParameters {
        get { VQVarioqubParameters(params: originalInstance.runtimeParams) }
        set { originalInstance.runtimeParams = newValue.vqParams }
    }

}
