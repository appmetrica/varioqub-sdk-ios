
// sourcery: AutoMockable
protocol FlagResolverOutput: AnyObject {
    func testIdTriggered(_ testId: VarioqubTestID)
}

// sourcery: AutoMockable
protocol FlagResolverInput: AnyObject {
    func updateResources(_ resources: [VarioqubResourceKey: VarioqubResource])
    func updateFlags(_ output: [VarioqubFlag: VarioqubConfigValue])
}
