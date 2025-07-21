import Foundation
#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubInstance {
    
    func setDefaults(_ defaults: [VQFlag: String], callback: VQDefaultsCompletion?) {
        originalInstance.setDefaults(convertDefaults(defaults), callback: callback)
    }

    func setDefaultsAndWait(_ defaults: [VQFlag: String]) {
        originalInstance.setDefaultsAndWait(convertDefaults(defaults))
    }

    func loadXml(at path: URL, completion: VQXmlCompletion?) {
        originalInstance.loadXml(at: path, callback: completion.map(wrapXmlCompletion(completion:)))
    }

    func loadXmlAndWait(at path: URL) throws {
        try originalInstance.loadXmlAndWait(at: path)
    }

    func loadXml(from data: Data, completion: VQXmlCompletion?) {
        originalInstance.loadXml(from: data, callback: completion.map(wrapXmlCompletion(completion:)))
    }

    func loadXmlAndWait(from data: Data) throws {
        try originalInstance.loadXmlAndWait(from: data)
    }
}

private func convertDefaults(_ defaults: [VQFlag: String]) -> [VarioqubFlag: String] {
    defaults.mapKeys({ VarioqubFlag(rawValue: $0) }, uniquingKeysWith: { $1 })
}

private func wrapXmlCompletion(completion: @escaping VQXmlCompletion) -> VarioqubDefaultsSetupable.XmlParserCallback {
    { completion($0.map(makeVQError(error:))) }
}
