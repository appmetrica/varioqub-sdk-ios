
import Foundation

enum ConditionItemTypeDTO {
    case regex(pattern: String)
}

struct ConditionItemModelDTO {
    var name: String
    var type: ConditionItemTypeDTO
}

enum ConditionTypeDTO {
    case runtimeParams
    case deeplinkParams
}

struct ConditionOrModelDTO {
    var ands: [ConditionItemModelDTO]
}

struct ConditionDTO {
    var type: ConditionTypeDTO
    var ors: [ConditionOrModelDTO]
}

struct ResourceDTO {
    var type: String
    var key: String
    var value: String
}

struct FlagValueDTO {
    var value: VarioqubValue?
    var testId: VarioqubTestID?
    var isNull: Bool
    var type: String? // TODO
    var conditions: [ConditionDTO]
}

struct FlagDTO {
    var values: [FlagValueDTO]
}

struct ResponseDTO {
    var flags: [VarioqubFlag: FlagDTO]
    var experimentId: String?
    var id: String
    var configVersion: String
    var resources: [ResourceDTO]
}

extension ResponseDTO {
    
    var testIds: [VarioqubTestID] {
        flags.values.flatMap { $0.values.compactMap(\.testId) }
    }
    
}
