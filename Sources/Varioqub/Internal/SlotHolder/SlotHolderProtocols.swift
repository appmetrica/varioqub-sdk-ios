
import Foundation

// sourcery: AutoMockable
protocol SlotHolderInput: AnyObject {
    func loadPendingData() -> NetworkDataModel
}

// sourcery: AutoMockable
protocol SlotHolderControlable: AnyObject {
    func activateConfig()
}

struct SlotHolderConfigModel {
    var response: ResponseDTO
    var fetchDate: Date?
}

// sourcery: AutoMockable
protocol SlotHolderReportable: AnyObject {
    func configApplied(oldConfig: SlotHolderConfigModel?, newConfig: SlotHolderConfigModel)
}
