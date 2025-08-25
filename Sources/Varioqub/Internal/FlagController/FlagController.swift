

final class FlagController {
    
    let output: FlagResolverInput
    
    init(output: FlagResolverInput) {
        self.output = output
    }
    
    private var response: ResponseDTO?
    private var runtimeParams: VarioqubParameters = .init()
    private var deeplinkParams: VarioqubParameters = .init()
    private var defaultsFlags: [VarioqubFlag: VarioqubValue] = [:]
}

extension FlagController: FlagControllerParamsInput {
    
    func updateRuntimeParams(_ params: VarioqubParameters) {
        self.runtimeParams = params
        updateFlags()
    }
    
    func updateDeeplinkParams(_ params: VarioqubParameters) {
        self.deeplinkParams = params
        updateFlags()
    }
    
    func updateDefaultValues(_ defaultValues: [VarioqubFlag: VarioqubValue]) {
        self.defaultsFlags = defaultValues
        updateFlags()
    }
    
}

extension FlagController: FlagControllerInput {
    
    func updateResponse(_ response: ResponseDTO) {
        self.response = response
        updateFlags()
        updateResources()
    }

}

private extension FlagController {
    
    func updateFlags() {
        let responseFlags = response?.flags ?? [:]
        
        func filter(_ flag: FlagDTO) -> VarioqubConfigValue? {
            FlagFilter.filter(
                flag: flag,
                runtimeParams: runtimeParams,
                deeplinkParams: deeplinkParams
            )
        }
        
        let defaultConfigValue = defaultsFlags.mapValues {
            VarioqubConfigValue(
                source: .inappDefault,
                value: $0,
                triggeredTestID: nil
            )
        }
        
        let mergedFlags = defaultConfigValue.merging(responseFlags.compactMapValues(filter),
                                                     uniquingKeysWith: { d, s in
            if s.value != nil {
                return s
            } else {
                var newValue = s
                newValue.value = d.value
                return newValue
            }
        })
        
        output.updateFlags(mergedFlags)
    }
    
    func updateResources() {
        guard let response = response else { return }
        
        let res = ResourcesConverter.convert(dtos: response.resources)
        
        output.updateResources(res)
    }
    
}
