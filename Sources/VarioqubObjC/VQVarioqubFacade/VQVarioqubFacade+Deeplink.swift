import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubFacade {

    func handleDeeplink(url: URL) -> Bool {
        mainInstance.handleDeeplink(url: url)
    }

}
