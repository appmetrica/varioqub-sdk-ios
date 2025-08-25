
@testable import Varioqub

enum ResponseDTODataProvider {
    
    static func simpleResponse(suffix: String = "") -> ResponseDTO {
        return ResponseDTO(
            flags: simpleFlags(),
            experimentId: "simpleExperiments\(suffix)",
            id: "simpleId\(suffix)",
            configVersion: "simpleConfigVersion\(suffix)",
            resources: resources()
        )
    }
    
    static func simpleDefaultValues() -> [VarioqubFlag: VarioqubValue] {
        return [
            VarioqubFlag(rawValue: "flag0"): VarioqubValue(string: "999"),
            VarioqubFlag(rawValue: "flag1"): VarioqubValue(string: "888"),
        ]
    }
    
    static func conditionsResponse(suffix: String = "") -> ResponseDTO {
        return ResponseDTO(
            flags: conditionFlags(),
            experimentId: "conditionExperiments\(suffix)",
            id: "conditionId\(suffix)",
            configVersion: "conditionConfigVersion\(suffix)",
            resources: resources()
        )
    }
    
    static func simpleAndConditionsResponse(suffix: String = "") -> ResponseDTO {
        return ResponseDTO(
            flags: simpleFlags().merging(conditionFlags(), uniquingKeysWith: { $1 }),
            experimentId: "conditionExperiments\(suffix)",
            id: "conditionId\(suffix)",
            configVersion: "conditionConfigVersion\(suffix)",
            resources: resources()
        )
    }
    
    static func simpleFlags() -> [VarioqubFlag: FlagDTO] {
        return [
            VarioqubFlag(rawValue: "flag1"): simpleStringFlag(),
            VarioqubFlag(rawValue: "flag2"): simpleIntFlag(),
            VarioqubFlag(rawValue: "flag3"): simpleBoolFlag(),
        ]
    }
    
    static func conditionFlags() -> [VarioqubFlag: FlagDTO] {
        let conditionFlags = [
            VarioqubFlag(rawValue: "flag4"): conditionsParamFlag(),
            VarioqubFlag(rawValue: "flag5"): conditionsDeeplinkFlag(),
        ]
        return conditionFlags
    }
    
    static func simpleStringFlag() -> FlagDTO {
        let values: [FlagValueDTO] = [
            FlagValueDTO(
                value: VarioqubValue(string: "test123"),
                testId: VarioqubTestID(rawValue: 123),
                isNull: false,
                conditions: []
            ),
            FlagValueDTO(
                value: VarioqubValue(string: "test234"),
                testId: VarioqubTestID(rawValue: 234),
                isNull: false,
                conditions: []
            ),
        ]
        return FlagDTO(values: values)
    }
    
    static func conditionsParamFlag() -> FlagDTO {
        let items1: [ConditionItemModelDTO] = [
            .init(name: "param1", type: .regex(pattern: "abc"))
        ]
        let conditionModels1: [ConditionOrModelDTO] = [
            ConditionOrModelDTO(ands: items1)
        ]
        let condition1: [ConditionDTO] = [
            ConditionDTO(type: .runtimeParams, ors: conditionModels1)
        ]
        
        let items2: [ConditionItemModelDTO] = [
            .init(name: "param2", type: .regex(pattern: "abc"))
        ]
        let conditionModels2: [ConditionOrModelDTO] = [
            ConditionOrModelDTO(ands: items2)
        ]
        let condition2: [ConditionDTO] = [
            ConditionDTO(type: .runtimeParams, ors: conditionModels2)
        ]
            
        let values: [FlagValueDTO] = [
            FlagValueDTO(
                value: VarioqubValue(string: "test123"),
                testId: VarioqubTestID(rawValue: 123),
                isNull: false,
                conditions: condition1
            ),
            FlagValueDTO(
                value: VarioqubValue(string: "test234"),
                testId: VarioqubTestID(rawValue: 234),
                isNull: false,
                conditions: condition2
            ),
        ]
        return FlagDTO(values: values)
    }
    
    static func conditionsDeeplinkFlag() -> FlagDTO {
        let items1: [ConditionItemModelDTO] = [
            .init(name: "param1", type: .regex(pattern: "abc"))
        ]
        let conditionModels1: [ConditionOrModelDTO] = [
            ConditionOrModelDTO(ands: items1)
        ]
        let condition1: [ConditionDTO] = [
            ConditionDTO(type: .deeplinkParams, ors: conditionModels1)
        ]
        
        let items2: [ConditionItemModelDTO] = [
            .init(name: "param2", type: .regex(pattern: "abc"))
        ]
        let conditionModels2: [ConditionOrModelDTO] = [
            ConditionOrModelDTO(ands: items2)
        ]
        let condition2: [ConditionDTO] = [
            ConditionDTO(type: .deeplinkParams, ors: conditionModels2)
        ]
            
        let values: [FlagValueDTO] = [
            FlagValueDTO(
                value: VarioqubValue(string: "test456"),
                testId: VarioqubTestID(rawValue: 456),
                isNull: false,
                conditions: condition1
            ),
            FlagValueDTO(
                value: VarioqubValue(string: "test567"),
                testId: VarioqubTestID(rawValue: 567),
                isNull: false,
                conditions: condition2
            ),
        ]
        return FlagDTO(values: values)
    }
    
    static func simpleIntFlag() -> FlagDTO {
        let values: [FlagValueDTO] = [
            FlagValueDTO(
                value: VarioqubValue(string: "123"),
                testId: VarioqubTestID(rawValue: 23),
                isNull: false,
                conditions: []
            ),
            FlagValueDTO(
                value: VarioqubValue(string: "234"),
                testId: VarioqubTestID(rawValue: 34),
                isNull: false,
                conditions: []
            ),
        ]
        return FlagDTO(values: values)
    }
    
    static func simpleBoolFlag() -> FlagDTO {
        let values: [FlagValueDTO] = [
            FlagValueDTO(
                value: VarioqubValue(string: "true"),
                testId: VarioqubTestID(rawValue: 12),
                isNull: false,
                conditions: []
            ),
            FlagValueDTO(
                value: VarioqubValue(string: "false"),
                testId: VarioqubTestID(rawValue: 23),
                isNull: false,
                conditions: []
            ),
        ]
        return FlagDTO(values: values)
    }
    
    static func resources() -> [ResourceDTO] {
        return [
            .init(type: "string", key: "key1", value: "value1"),
            .init(type: "string", key: "key2", value: "value2"),
            .init(type: "string", key: "key3", value: "value3"),
        ]
    }
    
}
