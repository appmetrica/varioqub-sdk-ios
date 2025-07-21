
import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubFacade {

    @objc(fetchConfigWithCompletion:)
    func fetchConfig(_ callback: VQFetchCompletion?) {
        mainInstance.fetchConfig(callback)
    }

    @objc(activateConfigWithCompletion:)
    func activateConfig(_ callback: VQActivateCompletion?) {
        mainInstance.activateConfig(callback)
    }

    func activateConfigAndWait() {
        mainInstance.activateConfigAndWait()
    }

    @objc(fetchAndActivateConfigWithCompletion:)
    func fetchAndActivateConfig(_ callback: VQFetchCompletion?) {
        mainInstance.fetchAndActivateConfig(callback)
    }

}


