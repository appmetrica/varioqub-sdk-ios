#if VQ_MODULES
import VarioqubUtils
#endif


final class FlagResolver {

    private let locker = UnfairLock()
    var activeData: [VarioqubFlag: VarioqubConfigValue] = [:]
    var activeResources: [VarioqubResourceKey: VarioqubResource] = [:]

    let output: FlagResolverOutput
    let executor: AsyncExecutor

    init(output: FlagResolverOutput, executor: AsyncExecutor) {
        self.output = output
        self.executor = executor
    }
}

extension FlagResolver: FlagResolverInput {
    
    func updateResources(_ resources: [VarioqubResourceKey: VarioqubResource]) {
        varioqubLogger.trace("resources: \(resources)")
        locker.lock {
            activeResources = resources
        }
    }
    
    func updateFlags(_ output: [VarioqubFlag: VarioqubConfigValue]) {
        varioqubLogger.trace("flags: \(output)")
        locker.lock {
            activeData = output
        }
    }

}

extension FlagResolver: VarioqubResourcesProvider {
    
    func resource(for key: VarioqubResourceKey) -> VarioqubResource? {
        varioqubLogger.trace("resource: \(key)")
        return locker.lock { activeResources[key] }
    }
    
}

extension FlagResolver: VarioqubFlagProvider {
    
    var allItems: [VarioqubFlag : VarioqubConfigValue] {
        varioqubLogger.trace("allItems")
        return locker.lock { activeData }
    }

    func get<T>(for flag: VarioqubFlag, type: T.Type, defaultValue: T?) -> T where T: VarioqubInitializableByValue {
        let value = locker.lock { activeData[flag] }
        varioqubLogger.trace("get flag=\(flag) type: \(type) defaultValue: \(defaultValue.debugDescription)")
        varioqubLogger.trace("get value=\(value.debugDescription)")
        sendIfNeeded(configValue: value)
        return FlagResolverStrategy.selectValue(configValue: value?.value, userProviderDefaultValue: defaultValue, type: type)
    }

    func getValue(for flag: VarioqubFlag) -> VarioqubConfigValue {
        let value = locker.lock { activeData[flag] }
        varioqubLogger.trace("get flag=\(flag) value=\(value.debugDescription)")
        sendIfNeeded(configValue: value)
        return value ?? VarioqubConfigValue(source: .defaultValue, value: nil, triggeredTestID: nil)
    }

}

private extension FlagResolver {

    func sendIfNeeded(configValue: VarioqubConfigValue?) {
        if let testId = configValue?.triggeredTestID {
            executor.execute { [output] in
                output.testIdTriggered(testId)
            }
        }
    }

}
