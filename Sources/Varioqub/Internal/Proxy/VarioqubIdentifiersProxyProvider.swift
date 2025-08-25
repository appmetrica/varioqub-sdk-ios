import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

final class VarioqubIdentifiersProxyProvider: VarioqubIdentifiersProvider {

    let executor: AsyncResultExecutor
    let underlyingProvider: VarioqubIdentifiersProvider

    init(executor: AsyncResultExecutor, underlyingProvider: VarioqubIdentifiersProvider) {
        self.executor = executor
        self.underlyingProvider = underlyingProvider
    }

    var varioqubIdentifier: String? {
        executor.executeAndReturn { [underlyingProvider] in underlyingProvider.varioqubIdentifier }
    }

}
