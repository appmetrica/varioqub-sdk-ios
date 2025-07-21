
import Foundation

#if VQ_MODULES
import Varioqub
#endif



public typealias MetricaUserID = String
public typealias MetricaDeviceID = String

public typealias VQIdCompletion = (MetricaUserID?, MetricaDeviceID?, NSError?) -> ()

@objc
public class VQActivateEventData: NSObject {
    public let fetchDate: Date?
    public let oldVersion: String?
    public let newVersion: String

    init(fetchDate: Date?, oldVersion: String?, newVersion: String) {
        self.fetchDate = fetchDate
        self.oldVersion = oldVersion
        self.newVersion = newVersion
    }
}

@objc
public protocol VQNameProvider: NSObjectProtocol {
    var varioqubName: String { get }
}

@objc
public protocol VQIdProvider: VQNameProvider {
    func fetchIdentifiers(completion: @escaping VQIdCompletion)
}

@objc
public protocol VQReporter: VQNameProvider {
    @objc
    optional func setExperiments(_ experiments: String)
    @objc
    optional func setTriggeredTestIds(_ testIds: VQTestIDSet)
    @objc
    optional func sendActivateEvent(_ eventData: VQActivateEventData)
}

