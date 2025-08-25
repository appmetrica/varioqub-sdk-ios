import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubFacade {

    var sendEventOnChangeConfig: Bool {
        get { mainInstance.sendEventOnChangeConfig }
        set { mainInstance.sendEventOnChangeConfig = newValue }
    }
    
    var clientFeatures: VQVarioqubClientFeatures {
        get { mainInstance.clientFeatures }
        set { mainInstance.clientFeatures = newValue }
    }

    var runtimeParams: VQVarioqubParameters {
        get { mainInstance.runtimeParams }
        set { mainInstance.runtimeParams = newValue }
    }
    
}
