import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

final class VarioqubRuntimeOptionAsyncProxy: VarioqubRuntimeOptionable {
    
    let executor: AsyncResultExecutor
    let underlyingOptions: VarioqubRuntimeOptionable
    
    init(executor: AsyncResultExecutor, underlyingOptions: VarioqubRuntimeOptionable) {
        self.executor = executor
        self.underlyingOptions = underlyingOptions
    }
    
    var sendEventOnChangeConfig: Bool {
        get { executor.executeAndReturn { [underlyingOptions] in underlyingOptions.sendEventOnChangeConfig } }
        set { executor.executeAndReturn { [underlyingOptions] in underlyingOptions.sendEventOnChangeConfig = newValue } }
    }
    
    var clientFeatures: ClientFeatures {
        get { executor.executeAndReturn { [underlyingOptions] in underlyingOptions.clientFeatures } }
        set { executor.executeAndReturn { [underlyingOptions] in underlyingOptions.clientFeatures = newValue } }
    }
    
    var runtimeParams: VarioqubParameters {
        get { executor.executeAndReturn { [underlyingOptions] in underlyingOptions.runtimeParams } }
        set { executor.executeAndReturn { [underlyingOptions] in underlyingOptions.runtimeParams = newValue } }
    }
    
}
