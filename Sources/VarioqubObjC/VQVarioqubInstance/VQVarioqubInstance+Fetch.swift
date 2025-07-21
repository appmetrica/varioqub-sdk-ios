import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
public extension VQVarioqubInstance {

    @objc(fetchConfigWithCompletion:)
    func fetchConfig(_ callback: VQFetchCompletion?) {
        originalInstance.fetchConfig(callback.map(wrapFetchCallback(callback:)))
    }

    @objc(activateConfigWithCompletion:)
    func activateConfig(_ callback: VQActivateCompletion?) {
        originalInstance.activateConfig(callback)
    }

    func activateConfigAndWait() {
        originalInstance.activateConfigAndWait()
    }

    @objc(fetchAndActivateConfigWithCompletion:)
    func fetchAndActivateConfig(_ callback: VQFetchCompletion?) {
        originalInstance.fetchAndActivateConfig(callback.map(wrapFetchCallback(callback:)))
    }

}

private func wrapFetchCallback(callback: @escaping VQFetchCompletion) -> VarioqubConfigurable.FetchCallback {
    {
        switch $0 {
        case .success:
            callback(.success, nil)
        case .error(let e):
            callback(.error, makeVQConfigFetchError(e))
        case .throttled:
            callback(.throttled, nil)
        case .cached:
            callback(.cached, nil)
        }
    }
}
