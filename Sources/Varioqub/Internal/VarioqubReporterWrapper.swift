#if VQ_MODULES
import VarioqubUtils
#endif


protocol ReporterStorable: AnyObject {
    var reporterData: ReporterData { get set }
}

final class VarioqubReporterWrapper: FlagResolverOutput, ConfigUpdaterFlagReporter, VariqubLoadable {

    private let underlyingReporter: VarioqubReporter?
    private let storage: ReporterStorable
    private let runtimeOptions: RuntimeOptionable

    private var rd = UnfairLocker<ReporterData>(wrappedValue: ReporterData())
    private let threadChecker: ThreadChecker

    init(storage: ReporterStorable,
         underlyingReporter: VarioqubReporter?,
         runtimeOptions: RuntimeOptionable,
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

    func configApplied(oldConfig: NetworkData?, newConfig: NetworkData) {
        threadChecker.check()
        
        varioqubLogger.trace("oldConfig.exp=\(oldConfig?.experimentId ?? "") newConfig.exp=\(newConfig.experimentId ?? "")")
        varioqubLogger.trace("oldConfig.ver=\(oldConfig?.configVersion ?? "") newConfig.ver=\(newConfig.configVersion)")
        let testIds = newConfig.testIds
        let new = rd.inplaceUpdate {
            $0.experiment = newConfig.experimentId ?? ""
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

    func saveData(rd: ReporterData) {
        storage.reporterData = rd
    }

    func createEventDate(oldConfig: NetworkData?, newConfig: NetworkData) -> VarioqubEventData {
        let data = VarioqubEventData(
            fetchDate: newConfig.fetchDate,
            oldVersion: oldConfig?.configVersion,
            newVersion: newConfig.configVersion
        )
        return data
    }

}
