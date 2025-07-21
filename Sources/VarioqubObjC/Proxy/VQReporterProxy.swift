
import Foundation
#if VQ_MODULES
import Varioqub
#endif

final class VQReporterProxy: VarioqubReporter {
    weak var objCReporter: VQReporter?

    init(objCReporter: VQReporter) {
        self.objCReporter = objCReporter
    }

    func setExperiments(_ experiments: String) {
        objCReporter?.setExperiments?(experiments)
    }

    func setTriggeredTestIds(_ triggeredTestIds: VarioqubTestIDSet) {
        let objcSet = VQTestIDSet(seq: triggeredTestIds.set.map { $0.rawValue })
        objCReporter?.setTriggeredTestIds?(objcSet)
    }
    
    func sendActivateEvent(_ eventData: VarioqubEventData) {
        let ed = VQActivateEventData(
            fetchDate: eventData.fetchDate,
            oldVersion: eventData.oldVersion,
            newVersion: eventData.newVersion
        )
        objCReporter?.sendActivateEvent?(ed)
    }

    
    var varioqubName: String {
        objCReporter?.varioqubName ?? ""
    }
    
}
