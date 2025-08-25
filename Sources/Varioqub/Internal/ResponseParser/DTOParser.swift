
import Foundation

enum DTOCreatorError: Error {
    case unknownValue(value: String, structName: String)
}

enum DTOParser {
    
    static func convert(_ response: PBResponse) -> ResponseDTO {
        let flags: [(VarioqubFlag, FlagDTO)] = response.flags.map {
            let name = VarioqubFlag(rawValue: $0.name)
            let model = convert(flag: $0)
            return (name, model)
        }
        let resources = response.resources.map(convert(res:))
        
        let result = ResponseDTO(
            flags: Dictionary(flags, uniquingKeysWith: { $1 }),
            experimentId: response.hasExperiments ? response.experiments : nil,
            id: response.id,
            configVersion: response.configVersion,
            resources: resources
        )
        return result
    }
    
    static private func convert(flag: PBFlag) -> FlagDTO {
        let values = flag.values.map(convert(value:))
        return FlagDTO(values: values)
    }
    
    static private func convert(value: PBValue) -> FlagValueDTO {
        
        let conditions: [ConditionDTO] = convert(conditionList: value.condition)
        
        let result = FlagValueDTO(
            value: VarioqubValue(value: value.value, hasValue: value.hasValue),
            testId: VarioqubTestID(value: value.testID, hasValue: value.hasTestID),
            isNull: value.hasIsNull && value.isNull,
            type: value.hasType ? value.type : nil,
            conditions: conditions
        )
        
        return result
    }
    
    static private func convert(conditionList: PBConditionList) -> [ConditionDTO] {
        return conditionList.values.mapAndSkipError(convert(condition:))
    }
    
    static private func convert(condition: PBCondition) throws -> ConditionDTO {
        
        let ors = condition.value.ors.map(convert(conditionOr:))
        let type = try convertToConditionType(string: condition.name)
        
        let result = ConditionDTO(
            type: type,
            ors: ors
        )
        
        return result
    }
    
    static private func convertToConditionType(string: String) throws -> ConditionTypeDTO {
        switch string {
        case "runtime_features": return .runtimeParams
        case "deeplink": return .deeplinkParams
        default: throw DTOCreatorError.unknownValue(value: string, structName: "ConditionTypeDTO")
        }
    }
    
    static private func convert(conditionOr: PBConditionOr) -> ConditionOrModelDTO {
        let ands = conditionOr.ands.mapAndSkipError(convert(conditionAnd:))
        
        let result = ConditionOrModelDTO(ands: ands)
        return result
    }
    
    static private func convert(conditionAnd: PBConditionAnd) throws -> ConditionItemModelDTO? {
        if (conditionAnd.hasClientSideCondition) {
            return try convert(condition: conditionAnd.clientSideCondition)
        } else {
            return nil
        }
    }
    
    static private func convert(condition: PBClientSideCondition) throws -> ConditionItemModelDTO {
        
        let type: ConditionItemTypeDTO
        
        switch condition.type {
        case "regex":
            type = .regex(pattern: condition.value)
        default:
            throw DTOCreatorError.unknownValue(value: condition.type, structName: "ConditionItemModelDTO.type")
        }
        
        let result = ConditionItemModelDTO(
            name: condition.name,
            type: type
        )
        
        return result
    }
    
    static private func convert(res: PBResource) -> ResourceDTO {
        
        let result = ResourceDTO(
            type: res.type,
            key: res.key,
            value: res.value
        )
        
        return result
    }
    
}

private extension Sequence {
    
    func mapAndSkipError<T>(_ m: (Element) throws -> T?) -> [T] {
        return compactMap {
            do {
                return try m($0)
            } catch let e {
                varioqubLogger.error("DTO converter error: \(e)")
                return nil
            }
        }
    }
    
    
    
}
