import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubInstance {

    func handleDeeplink(url: URL) -> Bool {
        originalInstance.handleDeeplink(url)
    }

}
