
import Foundation

#if VQ_LOGGER

#if VQ_MODULES
import Varioqub
#endif


@objc
final class VQVarioqubLogger: NSObject {
    
    @objc
    class func setupLogger() {
        setupVarioqubLogger()
    }
    
    @objc
    class func enableLogger() {
        enableVarioqubLogger()
    }
    
    @objc
    class func disableLogger() {
        disableVarioqubLogger()
    }
    
}

#endif
