import Foundation

#if VQ_MODULES
import Varioqub
#endif

@objc
public class VQVarioqubParameters: NSObject, NSCopying, NSMutableCopying {
    
    var vqParams: VarioqubParameters
    
    init(params: VarioqubParameters) {
        self.vqParams = params
    }
    
    @objc
    public required init(dictionary: [String: String]) {
        self.vqParams = .init(dictionary: dictionary)
        super.init()
    }
    
    @objc
    public var dictionary: [String: String] { return vqParams.dictionary }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        return VQMutableVarioqubParameters(params: vqParams)
    }
    
    @objc
    public class func clientFeatures(with dict: [String: String]) -> Self {
        return Self.init(dictionary: dict)
    }
    
}

@objc
public final class VQMutableVarioqubParameters: VQVarioqubParameters {
    
    @objc
    public func setFeature(_ feature: String, forKey key: String) {
        vqParams.setParameter(feature, forKey: key)
    }
    
    @objc
    public func removeFeature(forKey key: String) {
        vqParams.removeParameter(forKey: key)
    }
    
    @objc
    public func mergeWith(_ other: [String: String]) {
        vqParams.mergeWith(other)
    }
    
    @objc
    public func clearFeatures() {
        vqParams.clearParameters()
    }
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        return VQVarioqubParameters(params: vqParams)
    }
    
    public override func mutableCopy(with zone: NSZone? = nil) -> Any {
        return VQMutableVarioqubParameters(params: vqParams)
    }
    
}
