import Foundation
@testable import Varioqub

final class UserDefaultMock: UserDefaultsProtocol {
    var storage: [String: Any] = [:]
    
    
    func object(forKey defaultName: String) -> Any? {
        return storage[defaultName]
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        if let value = value {
            storage[defaultName] = value
        } else {
            storage.removeValue(forKey: defaultName)
        }
    }
    
    func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }
    
    func string(forKey defaultName: String) -> String? {
        return storage[defaultName] as? String
    }
    
    func array(forKey defaultName: String) -> [Any]? {
        return storage[defaultName] as? [Any]
    }
    
    func dictionary(forKey defaultName: String) -> [String : Any]? {
        return storage[defaultName] as? [String: Any]
    }
    
    func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }
    
    func stringArray(forKey defaultName: String) -> [String]? {
        return storage[defaultName] as? [String]
    }
    
    func integer(forKey defaultName: String) -> Int {
        return storage[defaultName] as? Int ?? 0
    }
    
    func float(forKey defaultName: String) -> Float {
        return storage[defaultName] as? Float ?? 0
    }
    
    func double(forKey defaultName: String) -> Double {
        return storage[defaultName] as? Double ?? 0
    }
    
    func bool(forKey defaultName: String) -> Bool {
        return storage[defaultName] as? Bool ?? false
    }
    
    func url(forKey defaultName: String) -> URL? {
        return storage[defaultName] as? URL
    }
    
    func set(_ value: Int, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func set(_ value: Float, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func set(_ value: Double, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        storage[defaultName] = value
    }
    
    func set(_ url: URL?, forKey defaultName: String) {
        storage[defaultName] = url
    }
}
