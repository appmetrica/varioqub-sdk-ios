import Foundation

enum FlagFilter {
    
    static func filter(flag: FlagDTO, runtimeParams: VarioqubParameters, deeplinkParams: VarioqubParameters) -> VarioqubConfigValue? {
        let flags = flag.values.filter {
            $0.conditions.isEmpty ||
            $0.conditions.allSatisfy { $0.isSatisfied(runtimeParams: runtimeParams, deeplinkParams: deeplinkParams) }
        }
        
        return flags.last.map {
            VarioqubConfigValue(
                source: .server,
                value: $0.isNull ? nil : $0.value,
                triggeredTestID: $0.testId
            )
        }
    }
    
}

extension ConditionDTO {
    
    func checkCondition(params: VarioqubParameters) -> Bool {
        ors.contains { orModel in
            orModel.ands.allSatisfy { item in
                item.isSatisfied(params: params)
            }
        }
    }
    
    func isSatisfied(runtimeParams: VarioqubParameters, deeplinkParams: VarioqubParameters) -> Bool {
        switch type {
        case .runtimeParams:
            return checkCondition(params: runtimeParams)
        case .deeplinkParams:
            return checkCondition(params: deeplinkParams)
        }
    }
    
}

extension ConditionItemModelDTO {
    
    func isSatisfied(params: VarioqubParameters) -> Bool {
        guard let value = params.parameter(for: name) else { return false }
        
        switch type {
        case .regex(let pattern):
            guard let r = try? NSRegularExpression(pattern: pattern) else { return false }
            let isMatches = r.matches(
                in: value,
                range: NSRange(location: 0, length: value.utf16.count)
            )
            return !isMatches.isEmpty
        }
    }
    
}
