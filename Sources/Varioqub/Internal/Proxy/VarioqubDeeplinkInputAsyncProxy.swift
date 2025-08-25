import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

final class VarioqubDeeplinkInputAsyncProxy: VarioqubDeeplinkInput {
    
    let executor: AsyncResultExecutor
    let underlyingDeepLinkInput: VarioqubDeeplinkInput
    
    init(executor: AsyncResultExecutor, underlyingDeepLinkInput: VarioqubDeeplinkInput) {
        self.executor = executor
        self.underlyingDeepLinkInput = underlyingDeepLinkInput
    }
    
    func handleDeeplink(_ url: URL) -> Bool {
        executor.executeAndReturn { [underlyingDeepLinkInput] in
            underlyingDeepLinkInput.handleDeeplink(url)
        }
    }
    
}
