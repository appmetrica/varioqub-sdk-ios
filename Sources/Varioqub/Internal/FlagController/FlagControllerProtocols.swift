// sourcery: AutoMockable
protocol FlagControllerInput: AnyObject {
    func updateResponse(_ response: ResponseDTO)
}

// sourcery: AutoMockable
protocol FlagControllerParamsInput: AnyObject {
    func updateRuntimeParams(_ params: VarioqubParameters)
    func updateDeeplinkParams(_ params: VarioqubParameters)
    func updateDefaultValues(_ defaultValues: [VarioqubFlag: VarioqubValue])
}
