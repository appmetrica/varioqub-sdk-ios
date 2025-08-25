#if VQ_MODULES
import VarioqubUtils
#endif


protocol ReporterStorable: AnyObject {
    var reporterData: ReporterDataDTO { get set }
}

final class VarioqubReporterWrapper: FlagResolverOutput, SlotHolderReportable, VariqubLoadable {

    private let underlyingReporter: VarioqubReporter?
    private let storage: ReporterStorable
    private let runtimeOptions: VarioqubRuntimeOptionable

    private var rd = UnfairLocker<ReporterDataDTO>(wrappedValue: ReporterDataDTO())
    private let threadChecker: ThreadChecker

    init(storage: ReporterStorable,
         underlyingReporter: VarioqubReporter?,
         runtimeOptions: VarioqubRuntimeOptionable,
         threadChecker: ThreadChecker) {
        self.underlyingReporter = underlyingReporter
        self.storage = storage
        self.runtimeOptions = runtimeOptions
        self.threadChecker = threadChecker
    }

    func load() {
        loadData()
    }

    func testIdTriggered(_ testId: VarioqubTestID) {
        threadChecker.check()
        let new = rd.inplaceUpdate {
            $0.appendTestId(testId)
        }

        underlyingReporter?.setTriggeredTestIds(new.testIds)

        saveData(rd: new)
    }

    func configApplied(oldConfig: SlotHolderConfigModel?, newConfig: SlotHolderConfigModel) {
        threadChecker.check()
        
        varioqubLogger.trace("oldConfig.exp=\(oldConfig?.response.experimentId ?? "") newConfig.exp=\(newConfig.response.experimentId ?? "")")
        varioqubLogger.trace("oldConfig.ver=\(oldConfig?.response.configVersion ?? "") newConfig.ver=\(newConfig.response.configVersion)")
        
        let testIds = newConfig.response.testIds
        let new = rd.inplaceUpdate {
            $0.experiment = newConfig.response.experimentId ?? ""
            $0.testIds.restrict(testIds)
        }

        underlyingReporter?.setExperiments(new.experiment)
        underlyingReporter?.setTriggeredTestIds(new.testIds)

        if runtimeOptions.sendEventOnChangeConfig {
            let eventData = createEventDate(oldConfig: oldConfig, newConfig: newConfig)
            underlyingReporter?.sendActivateEvent(eventData)
        }

        saveData(rd: new)
    }

}

extension VarioqubReporterWrapper {

    func loadData() {
        let data =  storage.reporterData
        self.rd.wrappedValue = data

        underlyingReporter?.setExperiments(data.experiment)
        underlyingReporter?.setTriggeredTestIds(data.testIds)
    }

    func saveData(rd: ReporterDataDTO) {
        storage.reporterData = rd
    }

    func createEventDate(oldConfig: SlotHolderConfigModel?, newConfig: SlotHolderConfigModel) -> VarioqubEventData {
        let data = VarioqubEventData(
            fetchDate: newConfig.fetchDate,
            oldVersion: oldConfig?.response.configVersion,
            newVersion: newConfig.response.configVersion
        )
        return data
    }

}
