
#if VQ_MODULES
import VarioqubUtils
#endif

final class InternalOptionProxy: RuntimeOptionable {
    
    let executor: AsyncResultExecutor
    let underlyingOptions: RuntimeOptionable

    init(executor: AsyncResultExecutor, underlyingOptions: RuntimeOptionable) {
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
    
}
