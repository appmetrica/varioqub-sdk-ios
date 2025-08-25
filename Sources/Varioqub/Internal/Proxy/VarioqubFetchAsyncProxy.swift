import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

final class VarioqubFetchAsyncProxy: VarioqubConfigurable {

    let executor: AsyncExecutor & AsyncResultExecutor
    let outputExecutor: AsyncExecutor
    let underlyingFetcher: VarioqubConfigurable

    init(executor: AsyncExecutor & AsyncResultExecutor, outputExecutor: AsyncExecutor, underlyingFetcher: VarioqubConfigurable) {
        self.executor = executor
        self.outputExecutor = outputExecutor
        self.underlyingFetcher = underlyingFetcher
    }

    func fetchConfig(_ callback: FetchCallback?) {
        executor.execute { [underlyingFetcher, outputExecutor] in
            let wrappedCallback: FetchCallback? = callback.map {
                c in { ans in outputExecutor.execute { c(ans) } }
            }
            underlyingFetcher.fetchConfig(wrappedCallback)
        }
    }

    func activateConfig(_ callback: ActivateCallback?) {
        executor.execute { [underlyingFetcher, outputExecutor] in
            let wrappedCallback: ActivateCallback? = callback.map {
                c in { outputExecutor.execute { c() } }
            }
            underlyingFetcher.activateConfig(wrappedCallback)
        }
    }

    func activateConfigAndWait() {
        executor.executeAndReturn { [underlyingFetcher] in
            underlyingFetcher.activateConfigAndWait()
        }
    }

    func fetchAndActivateConfig(_ callback: FetchCallback?) {
        executor.execute { [underlyingFetcher, outputExecutor] in
            let wrappedCallback: FetchCallback? = callback.map {
                c in { ans in outputExecutor.execute { c(ans) } }
            }
            underlyingFetcher.fetchAndActivateConfig(wrappedCallback)
        }
    }

}
