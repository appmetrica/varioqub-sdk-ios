
import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

struct NetworkDataDSOv100: Codable, Equatable {
    var version: String
    var data: Data
    var fetchDate: Date
}

struct NetworkDataDSOv0: Codable, Equatable {
    struct Value: Codable, Equatable {
        var flag: String
        var value: String?
        var testId: Int64?
    }

    var id: String
    var experimentId: String?
    var flags: [Value]
    var configVersion: String?
    var fetchDate: Int64?
}
