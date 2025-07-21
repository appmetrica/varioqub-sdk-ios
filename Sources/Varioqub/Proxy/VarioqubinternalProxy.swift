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

final class VarioqubDefaultsAsyncProxy: VarioqubDefaultsSetupable {
    let executor: CombinedAsyncExecutor
    let outputExecutor: AsyncExecutor
    let underlyingDefaults: VarioqubDefaultsSetupable

    init(executor: CombinedAsyncExecutor, outputExecutor: AsyncExecutor, underlyingDefaults: VarioqubDefaultsSetupable) {
        self.executor = executor
        self.outputExecutor = outputExecutor
        self.underlyingDefaults = underlyingDefaults
    }

    func setDefaults(_ defaults: [VarioqubFlag: String], callback: DefaultsCallback?) {
        executor.execute { [underlyingDefaults, outputExecutor] in
            let wrappedCallback: DefaultsCallback? = callback.map {
                c in { outputExecutor.execute { c() } }
            }
            underlyingDefaults.setDefaults(defaults, callback: wrappedCallback)
        }
    }

    func loadXml(at path: URL, callback: XmlParserCallback?) {
        executor.execute { [underlyingDefaults, outputExecutor] in
            let wrappedCallback: XmlParserCallback? = callback.map {
                c in { ans in outputExecutor.execute { c(ans) } }
            }
            underlyingDefaults.loadXml(at: path, callback: wrappedCallback)
        }
    }

    func loadXml(from data: Data, callback: XmlParserCallback?) {
        executor.execute { [underlyingDefaults, outputExecutor] in
            let wrappedCallback: XmlParserCallback? = callback.map {
                c in { ans in outputExecutor.execute { c(ans) } }
            }
            underlyingDefaults.loadXml(from: data, callback: wrappedCallback)
        }
    }

    func setDefaultsAndWait(_ defaults: [VarioqubFlag: String]) {
        executor.executeAndReturn { [underlyingDefaults] in
            underlyingDefaults.setDefaultsAndWait(defaults)
        }
    }

    func loadXmlAndWait(at path: URL) throws {
        try executor.executeAndReturn { [underlyingDefaults] in
            try underlyingDefaults.loadXmlAndWait(at: path)
        }
    }

    func loadXmlAndWait(from data: Data) throws {
        try executor.executeAndReturn { [underlyingDefaults] in
            try underlyingDefaults.loadXmlAndWait(from: data)
        }
    }

}

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
