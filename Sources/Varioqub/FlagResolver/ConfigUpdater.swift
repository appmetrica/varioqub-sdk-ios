import Foundation

#if VQ_MODULES
import VarioqubUtils
#endif

enum Source {
    case defaults
    case network
}

// sourcery: AutoMockable
protocol ConfigUpdaterInput: AnyObject {
    func updateNetworkData(_ data: NetworkData)
    func updateDefaultsFlags(_ flags: [VarioqubFlag: VarioqubValue])
}

// sourcery: AutoMockable
protocol ConfigUpdaterOutput: AnyObject {
    func updateFlags(_ output: [VarioqubFlag: VarioqubConfigValue])
}

// sourcery: AutoMockable
protocol ConfigUpdaterControllable: AnyObject {
    func activateConfig()
}

// sourcery: AutoMockable
protocol ConfigUpdaterFlagReporter: AnyObject {
    func configApplied(oldConfig: NetworkData?, newConfig: NetworkData)
}

final class ConfigUpdater: ConfigUpdaterInput, ConfigUpdaterControllable, VarioqubIdentifiersProvider, VariqubLoadable {

    let output: ConfigUpdaterOutput
    let reporter: ConfigUpdaterFlagReporter
    let persistentStorage: NetworkDataStorable

    let threadChecker: ThreadChecker

    private var isPendingLoaded = false
    private var isActiveLoaded = false

    init(output: ConfigUpdaterOutput, reporter: ConfigUpdaterFlagReporter,
         persistentStorage: NetworkDataStorable, threadChecker: ThreadChecker) {
        self.output = output
        self.persistentStorage = persistentStorage
        self.reporter = reporter
        self.threadChecker = threadChecker
    }

    private var defaultsFlags: [VarioqubFlag: VarioqubValue] = [:]
    private var pendingData: NetworkData?
    private var activeData: NetworkData?
    private var shouldNotifyExperimentChanged: Bool?

    var varioqubIdentifier: String? {
        threadChecker.check()
        loadPendingDataIfNeed()
        return pendingData?.id
    }

    func updateNetworkData(_ data: NetworkData) {
        threadChecker.check()

        varioqubLogger.debug("network data updated: \(data)")

        loadPendingDataIfNeed()
        loadActiveDataIfNeed()

        let prevExp = pendingData?.experimentId ?? activeData?.experimentId
        let shouldNotifyExperimentChanged = prevExp != data.experimentId

        self.shouldNotifyExperimentChanged = shouldNotifyExperimentChanged
        pendingData = data

        persistentStorage.saveNetworkData(data.dto, for: .pending)
        persistentStorage.isShouldNotifyExperimentChanged = shouldNotifyExperimentChanged
    }

    func updateDefaultsFlags(_ flags: [VarioqubFlag: VarioqubValue]) {
        threadChecker.check()

        varioqubLogger.debug("defaults flag updated")
        varioqubLogger.trace("default flags: \(flags.loggerString)")

        defaultsFlags = flags

        sendFlags()
    }

    func activateConfig() {
        varioqubLogger.trace("activate new config")
        threadChecker.check()

        loadPendingDataIfNeed()
        loadActiveDataIfNeed()
        
        let oldData = activeData
        let newData = pendingData

        let notifyExperimentChanged = loadShouldNotifyExperimentChangedIfNeed()
        
        shouldNotifyExperimentChanged = false
        persistentStorage.isShouldNotifyExperimentChanged = false

        activeData = pendingData
        persistentStorage.saveNetworkData(activeData?.dto, for: .active)

        if notifyExperimentChanged, let newData = newData {
            reporter.configApplied(oldConfig: oldData, newConfig: newData)
        }

        sendFlags()
    }

    func load() {
        threadChecker.check()

        loadActiveDataIfNeed()

        sendFlags()
    }

}

private extension ConfigUpdater {

    func loadShouldNotifyExperimentChangedIfNeed() -> Bool {
        threadChecker.check()

        if let shouldNotifyExperimentChanged = shouldNotifyExperimentChanged {
            return shouldNotifyExperimentChanged
        } else {
            let ans = persistentStorage.isShouldNotifyExperimentChanged
            shouldNotifyExperimentChanged = ans
            return ans
        }
    }

    func loadPendingDataIfNeed() {
        threadChecker.check()

        if !isPendingLoaded {
            pendingData = persistentStorage.loadNetworkData(for: .pending)?.value
            isPendingLoaded = true
        }
    }

    func loadActiveDataIfNeed() {
        threadChecker.check()

        if !isActiveLoaded {
            activeData = persistentStorage.loadNetworkData(for: .active)?.value
            isActiveLoaded = true
        }
    }

    func sendFlags() {
        threadChecker.check()
        loadActiveDataIfNeed()

        var dict = defaultsFlags.mapValues { VarioqubConfigValue(source: .inappDefault, value: $0, triggeredTestID: nil) }
        if let activeFlags = activeData?.flags {
            activeFlags.forEach { (k, v) in
                if let value = v.value {
                    dict[k] = .init(source: .server, value: value, triggeredTestID: v.testId)
                } else {
                    var r = dict[k] ?? VarioqubConfigValue(source: .defaultValue, value: nil, triggeredTestID: v.testId)
                    r.triggeredTestID = v.testId
                    dict[k] = r
                }
            }
        }

        output.updateFlags(dict)
    }

}

private extension Dictionary where Key: CustomStringConvertible, Value: CustomStringConvertible {

    var loggerString: String {
        map { "key=\($0) value=\($1)" }.joined(separator: "\n")
    }

}

private extension Dictionary where Key: CustomStringConvertible, Value == VarioqubTransferValue {

    var loggerString: String {
        map { "key=\($0) value=\($1.value?.description ?? "") testId=\($1.testId?.description ?? "")" }.joined(separator: "\n")
    }

}

private extension NetworkData {
    var dto: NetworkDataDTO {
        let flags: [NetworkDataDTO.Value] = self.flags.map { (k, v) in
            NetworkDataDTO.Value(flag: k.rawValue, value: v.value?.rawValue, testId: v.testId?.rawValue)
        }
        
        return .init(id: id,
                     experimentId: experimentId,
                     flags: flags,
                     configVersion: configVersion,
                     fetchDate: fetchDate.map { Int64($0.timeIntervalSince1970) }
        )
    }
}

private extension NetworkDataDTO {
    var value: NetworkData {
        let kvPairs: [(VarioqubFlag, VarioqubTransferValue)] = self.flags.map {
            let k = VarioqubFlag(rawValue: $0.flag)
            let v = VarioqubTransferValue(
                    value: $0.value.map { VarioqubValue(string: $0) },
                    testId: $0.testId.map { VarioqubTestID(rawValue: $0) }
            )
            return (k, v)
        }
        let flags: [VarioqubFlag: VarioqubTransferValue] = .init(kvPairs, uniquingKeysWith: {
            varioqubLogger.error("duplicated key: \($0)")
            return $1
        })
        
        return .init(
            flags: flags,
            experimentId: experimentId,
            id: id,
            configVersion: configVersion ?? "",
            fetchDate: fetchDate.map { Date(timeIntervalSince1970: TimeInterval($0)) }
        )
    }
}
