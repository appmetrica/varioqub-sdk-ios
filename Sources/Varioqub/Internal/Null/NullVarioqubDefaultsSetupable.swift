
import Foundation

final class NullVarioqubDefaultsSetupable: VarioqubDefaultsSetupable {
    func setDefaults(_ defaults: [VarioqubFlag : String], callback: DefaultsCallback?) {
        callback?()
    }
    
    func setDefaultsAndWait(_ defaults: [VarioqubFlag : String]) {
        
    }
    
    func loadXml(at path: URL, callback: XmlParserCallback?) {
        callback?(nil)
    }
    
    func loadXmlAndWait(at path: URL) throws {
        
    }
    
    func loadXml(from data: Data, callback: XmlParserCallback?) {
        callback?(nil)
    }
    
    func loadXmlAndWait(from data: Data) throws {
        
    }
    
    
}
