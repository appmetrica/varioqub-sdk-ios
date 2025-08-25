
import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

struct SlotItem {
    var response: ResponseDTO?
    var fetchDate: Date?
}

final class SlotHolder {
    
    let settings: VarioqubSettingsProtocol
    let output: FlagControllerInput
    let reporter: SlotHolderReportable
    
    init(
        settings: VarioqubSettingsProtocol,
        output: FlagControllerInput,
        reporter: SlotHolderReportable
    ) {
        self.settings = settings
        self.output = output
        self.reporter = reporter
    }
    
    private var pending: SlotItem?
    private var active: SlotItem?
    
}

extension SlotHolder: VariqubLoadable {
    
    func load() {
        if let response = loadActiveIfNeeded()?.response {
            output.updateResponse(response)
        }
    }
    
}

extension SlotHolder: VarioqubIdentifiersProvider {
    
    var varioqubIdentifier: String? {
        loadActiveIfNeeded()?.response?.id
    }
    
}

extension SlotHolder: ConfigFetcherOutput {

    func updateNetworkData(_ nm: NetworkDataModel) throws {
        loadPendingIfNeeded()
        loadActiveIfNeeded()
        
        let prevExp = pending?.response?.experimentId
        let newModel = try nm.data.parseResponseDTO()
        let shouldNotifyExperimentChanged = prevExp != newModel.experimentId
        
        pending = .init(response: newModel, fetchDate: nm.fetchDate)
        saveDataModel(model: nm, key: .pending)
        settings.isShouldNotifyExperimentChanged = shouldNotifyExperimentChanged
    }
    
}

extension SlotHolder: SlotHolderControlable {
    
    func activateConfig() {
        let pendingData = loadPendingIfNeeded()
        let activeData = loadActiveIfNeeded()
        
        copyPendingToActive()
        
        if let dto = pending?.response {
            output.updateResponse(dto)
        }
        
        let shouldNotify = settings.isShouldNotifyExperimentChanged
        settings.isShouldNotifyExperimentChanged = false
        
        if shouldNotify, let newData = pendingData, let newResponse = newData.response {
            let oldModel: SlotHolderConfigModel?
            if let oldData = activeData, let oldResponse = oldData.response {
                oldModel = .init(response: oldResponse, fetchDate: oldData.fetchDate)
            } else {
                oldModel = nil
            }
            
            let newModel = SlotHolderConfigModel(response: newResponse, fetchDate: newData.fetchDate)
            
            reporter.configApplied(oldConfig: oldModel, newConfig: newModel)
        }
    }
    
}

private extension SlotHolder {
    
    @discardableResult
    func loadPendingIfNeeded() -> SlotItem? {
        pending = loadIfNeeded(key: .pending, currentValue: pending)
        return pending
    }
    
    @discardableResult
    func loadActiveIfNeeded() -> SlotItem? {
        active = loadIfNeeded(key: .active, currentValue: active)
        return active
    }
    
    func loadIfNeeded(key: NetworkDataKeyDSO, currentValue: SlotItem?) -> SlotItem? {
        if currentValue != nil {
            return currentValue
        }
        
        var result = currentValue
        if let dm = loadDataModel(key: key) {
            result = .init(response: try? dm.data.parseResponseDTO(), fetchDate: dm.fetchDate)
        } else if let om = loadOldModel(key: key) {
            let date = om.fetchDate.map { Date(timeIntervalSince1970: TimeInterval($0)) }
            result = .init(response: om.toResponseDTO(), fetchDate: date)
        }
        
        return result
    }
    
    func saveDataModel(model: NetworkDataModel, key: NetworkDataKeyDSO) {
        let dso = convertToDSO(model)
        let data = try? JSONEncoder().encode(dso)
        
        settings.storeNetworkModel(data, for: key.rawValue)
    }
    
    func loadDataModel(key: NetworkDataKeyDSO) -> NetworkDataModel? {
        return settings.loadNetworkModel(for: key.rawValue)?.loadNetworkDataModel()
    }
    
    func loadOldModel(key: NetworkDataKeyDSO) -> NetworkDataDSOv0? {
        return settings.loadNetworkDSOv0(for: key.rawValue)?.loadOldDataModel()
    }
    
    func copyPendingToActive() {
        if let pendingData = settings.loadNetworkModel(for: NetworkDataKeyDSO.pending.rawValue),
            !pendingData.isEmpty,
            let model = pendingData.loadNetworkDataModel() {
            
            pending = .init(response: try? model.data.parseResponseDTO(), fetchDate: model.fetchDate)
            settings.storeNetworkModel(pendingData, for: NetworkDataKeyDSO.active.rawValue)
        } else if let pendingData = settings.loadNetworkDSOv0(for: NetworkDataKeyDSO.pending.rawValue),
                  !pendingData.isEmpty,
                  let model = pendingData.loadOldDataModel() {
            let date = model.fetchDate.map { Date(timeIntervalSince1970: TimeInterval($0)) }
            pending = .init(response: model.toResponseDTO(), fetchDate: date)
        } else {
            return
        }
        
        active = pending
    }
    
}

private extension Data {
    
    func parseResponseDTO() throws -> ResponseDTO {
        let r = try PBResponse(serializedBytes: self)
        return DTOParser.convert(r)
    }
    
}

private extension Data {
    
    func loadNetworkDataModel() -> NetworkDataModel? {
        guard let dso = try? JSONDecoder().decode(NetworkDataDSOv100.self, from: self) else { return nil }
        return convertToModel(dso)
    }
    
    func loadOldDataModel() -> NetworkDataDSOv0? {
        return try? JSONDecoder().decode(NetworkDataDSOv0.self, from: self)
    }
    
}

extension NetworkDataDSOv0.Value {
    
    func toFlagDTO() -> FlagDTO {
        let value = FlagValueDTO(
            value: value.map { VarioqubValue(string: $0) },
            testId: testId.map { VarioqubTestID(rawValue: $0) },
            isNull: testId != nil,
            type: nil,
            conditions: []
        )
        return FlagDTO(values: [value])
    }
    
}

extension NetworkDataDSOv0 {
    
    func toResponseDTO() -> ResponseDTO {
        
        let flags = flags.map { (VarioqubFlag(rawValue: $0.flag), $0.toFlagDTO()) }
        
        return ResponseDTO(
            flags: Dictionary(flags, uniquingKeysWith: { $1 }),
            experimentId: experimentId,
            id: id,
            configVersion: configVersion ?? "",
            resources: []
        )
    }
    
}

private func convertToDSO(_ model: NetworkDataModel) -> NetworkDataDSOv100 {
    return NetworkDataDSOv100(
        version: model.version.description,
        data: model.data,
        fetchDate: model.fetchDate
    )
}

private func convertToModel(_ dso: NetworkDataDSOv100) -> NetworkDataModel? {
    guard let version = Version(stringValue: dso.version) else { return nil }
    return NetworkDataModel(
        version: version,
        data: dso.data,
        fetchDate: dso.fetchDate
    )
}
