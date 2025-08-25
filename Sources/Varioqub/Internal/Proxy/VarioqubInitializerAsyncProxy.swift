import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

final class VarioqubInitializerAsyncProxy: VarioqubInitializable {

    let executor: AsyncResultExecutor
    let underlyingInitiazer: VarioqubInitializable

    init(executor: AsyncResultExecutor, underlyingInitiazer: VarioqubInitializable) {
        self.executor = executor
        self.underlyingInitiazer = underlyingInitiazer
    }

    func start() {
        executor.executeAndReturn { [underlyingInitiazer] in
            underlyingInitiazer.start()
        }
    }

}
