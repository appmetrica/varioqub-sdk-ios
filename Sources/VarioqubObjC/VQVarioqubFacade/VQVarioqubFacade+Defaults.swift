
import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubFacade {

    func setDefaults(_ defaults: [VQFlag: String], callback: VQDefaultsCompletion?) {
        mainInstance.setDefaults(defaults, callback: callback)
    }

    func setDefaultsAndWait(_ defaults: [VQFlag: String]) {
        mainInstance.setDefaultsAndWait(defaults)
    }

    func loadXml(at path: URL, completion: VQXmlCompletion?) {
        mainInstance.loadXml(at: path, completion: completion)
    }

    func loadXmlAndWait(at path: URL) throws {
        try mainInstance.loadXmlAndWait(at: path)
    }

    func loadXml(from data: Data, completion: VQXmlCompletion?) {
        mainInstance.loadXml(from: data, completion: completion)
    }

    func loadXmlAndWait(from data: Data) throws {
        try mainInstance.loadXmlAndWait(from: data)
    }

}

