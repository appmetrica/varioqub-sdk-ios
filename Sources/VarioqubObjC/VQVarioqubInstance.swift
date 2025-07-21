import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
public final class VQVarioqubInstance: NSObject {
    
    let originalInstance: VarioqubInstance
    
    init(originalInstance: VarioqubInstance) {
        self.originalInstance = originalInstance
        super.init()
    }
    
    @objc
    static let null = VQVarioqubInstance(originalInstance: .null)
    
}
