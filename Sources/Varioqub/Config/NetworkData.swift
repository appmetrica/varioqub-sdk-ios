
import Foundation

struct VarioqubTransferValue {
    var value: VarioqubValue?
    var testId: VarioqubTestID?

    init(value: VarioqubValue?, testId: VarioqubTestID?) {
        self.value = value
        self.testId = testId
    }
}

struct NetworkData {
    var flags: [VarioqubFlag: VarioqubTransferValue]
    var experimentId: String?
    var id: String
    var configVersion: String
    var fetchDate: Date?
    
    var testIds: [VarioqubTestID] {
        return flags.values.compactMap { $0.testId }
    }
}
