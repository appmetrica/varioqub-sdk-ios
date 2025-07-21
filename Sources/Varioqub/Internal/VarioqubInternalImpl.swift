import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif


final class VarioqubInternalImpl {

    private let mainFactory: MainFactoryProtocol
    private lazy var configFetcher: ConfigFetchable = mainFactory.configFetcher
    private lazy var flagUpdater: ConfigUpdaterInput = mainFactory.flagUpdater
    private lazy var flagResolver: ConfigUpdaterControllable = mainFactory.flagControllable
    private let threadChecker: ThreadChecker

    init(mainFactory: MainFactoryProtocol) {
        self.mainFactory = mainFactory
        self.threadChecker = mainFactory.threadChecker
    }

}

extension VarioqubInternalImpl: VarioqubConfigurable {

    func fetchConfig(_ callback: FetchCallback?) {
        varioqubLogger.trace("fetchConfig")
        threadChecker.check()

        configFetcher.fetchExperiments(callback: { [threadChecker] in
            varioqubLogger.trace("fetchConfig completed \($0)")
            threadChecker.check()
            callback?($0)
        })
    }

    func activateConfig(_ callback: ActivateCallback?) {
        varioqubLogger.trace("activatedConfig")
        threadChecker.check()

        flagResolver.activateConfig()
        callback?()
    }

    func activateConfigAndWait() {
        activateConfig(nil)
    }

    func fetchAndActivateConfig(_ callback: FetchCallback?) {
        varioqubLogger.trace("fetchAndActivateConfig")
        threadChecker.check()

        configFetcher.fetchExperiments { [weak self, threadChecker] ans in
            varioqubLogger.trace("fetchAndActivateConfig completed: \(ans)")
            threadChecker.check()

            defer { callback?(ans) }

            if !ans.isError {
                self?.flagResolver.activateConfig()
            }
        }
    }

}

extension VarioqubInternalImpl: VarioqubDefaultsSetupable {

    func setDefaults(_ defaults: [VarioqubFlag: String], callback: DefaultsCallback?) {
        varioqubLogger.trace("setDefaults: \(defaults)")
        threadChecker.check()

        let flags = defaults.mapValues { VarioqubValue(string: $0) }
        flagUpdater.updateDefaultsFlags(flags)
        callback?()
    }

    public func loadXml(at path: URL, callback: XmlParserCallback?) {
        varioqubLogger.trace("loadXml at \(path)")
        threadChecker.check()

        handleParser(XmlParser(url: path), callback: callback)
    }

    func loadXml(from data: Data, callback: XmlParserCallback?) {
        varioqubLogger.trace("loadXml \(data.base64EncodedString())")
        threadChecker.check()

        handleParser(XmlParser(data: data), callback: callback)
    }

    func setDefaultsAndWait(_ defaults: [VarioqubFlag: String]) {
        setDefaults(defaults, callback: nil)
    }

    func loadXmlAndWait(at path: URL) throws {
        try handleParser(XmlParser(url: path))
    }

    func loadXmlAndWait(from data: Data) throws {
        try handleParser(XmlParser(data: data))
    }

}

private extension VarioqubInternalImpl {

    func handleParser(_ parser: XmlParser, callback: XmlParserCallback?) {
        let error: Error?
        defer { callback?(error) }

        do {
            try handleParser(parser)
            error = nil
        } catch let e {
            error = e
            varioqubLogger.error("\(e)")
        }
    }

    func handleParser(_ parser: XmlParser) throws {
        let data = try parser.parse()
        flagUpdater.updateDefaultsFlags(data)
    }

}
