import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif


final class VarioqubInternalImpl {

    private let configFetcher: ConfigFetchable
    private let slotController: SlotHolderControlable
    private let flagController: FlagControllerParamsInput
    private let runtimeOptions: VarioqubRuntimeOptionable & RuntimeOptionsProtocol
    private let threadChecker: ThreadChecker
    
    init(
        configFetcher: ConfigFetchable,
        slotController: SlotHolderControlable,
        flagController: FlagControllerParamsInput,
        runtimeOptions: VarioqubRuntimeOptionable & RuntimeOptionsProtocol,
        threadChecker: ThreadChecker
    ) {
        self.configFetcher = configFetcher
        self.slotController = slotController
        self.flagController = flagController
        self.runtimeOptions = runtimeOptions
        self.threadChecker = threadChecker
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

        slotController.activateConfig()
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
                self?.slotController.activateConfig()
            }
        }
    }

}

extension VarioqubInternalImpl: VarioqubDefaultsSetupable {

    func setDefaults(_ defaults: [VarioqubFlag: String], callback: DefaultsCallback?) {
        varioqubLogger.trace("setDefaults: \(defaults)")
        threadChecker.check()

        let flags = defaults.mapValues { VarioqubValue(string: $0) }
        updateDefaultValues(flags)
        
        callback?()
    }

    func loadXml(at path: URL, callback: XmlParserCallback?) {
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

extension VarioqubInternalImpl: VarioqubRuntimeOptionable {
    
    var sendEventOnChangeConfig: Bool {
        get { return runtimeOptions.sendEventOnChangeConfig }
        set { runtimeOptions.sendEventOnChangeConfig = newValue }
    }

    var clientFeatures: VarioqubClientFeatures {
        get { return runtimeOptions.clientFeatures }
        set { runtimeOptions.clientFeatures = newValue }
    }

    var runtimeParams: VarioqubParameters {
        get { runtimeOptions.runtimeParams }
        set {
            runtimeOptions.runtimeParams = newValue
            flagController.updateRuntimeParams(newValue)
        }
    }
    
}

extension VarioqubInternalImpl: VarioqubDeeplinkInput {
    
    func handleDeeplink(_ url: URL) -> Bool {
        let params = DeeplinkParser.parse(url: url)
        
        runtimeOptions.deeplinkParams = params
        flagController.updateDeeplinkParams(params)
        
        return true
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
        updateDefaultValues(data)
    }
    
    func updateDefaultValues(_ values: [VarioqubFlag: VarioqubValue]) {
        flagController.updateDefaultValues(values)
    }

}
