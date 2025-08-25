import Foundation

#if VQ_MODULES
import Varioqub
#endif

@objc
public class VQVarioqubClientFeatures: NSObject, NSCopying, NSMutableCopying {
    
    var clientFeatures: VarioqubClientFeatures
    
    init(clientFeatures: ClientFeatures) {
        self.clientFeatures = clientFeatures
    }
    
    @objc
    public required init(dictionary: [String: String]) {
        self.clientFeatures = .init(dictionary: dictionary)
        super.init()
    }
    
    @objc
    public var features: [String: String] { return clientFeatures.features }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
    
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        return VQMutableVarioqubClientFeatures(clientFeatures: clientFeatures)
    }
    
    @objc
    public class func clientFeatures(with dict: [String: String]) -> Self {
        return Self.init(dictionary: dict)
    }
    
}

@objc
public final class VQMutableVarioqubClientFeatures: VQVarioqubClientFeatures {
    
    @objc
    public func setFeature(_ feature: String, forKey key: String) {
        clientFeatures.setFeature(feature, forKey: key)
    }
    
    @objc
    public func removeFeature(forKey key: String) {
        clientFeatures.removeFeature(forKey: key)
    }
    
    @objc
    public func mergeWith(_ other: [String: String]) {
        clientFeatures.mergeWith(other)
    }
    
    @objc
    public func clearFeatures() {
        clientFeatures.clearFeatures()
    }
    
    public override func copy(with zone: NSZone? = nil) -> Any {
        return VQVarioqubClientFeatures(clientFeatures: clientFeatures)
    }
    
    public override func mutableCopy(with zone: NSZone? = nil) -> Any {
        return VQMutableVarioqubClientFeatures(clientFeatures: clientFeatures)
    }
    
}
