
@testable import Varioqub

final class RuntimeOptionsMock: RuntimeOptionsProtocol, VarioqubRuntimeOptionable {
    
    var runtimeParams: VarioqubParameters = .init()
    var deeplinkParams: VarioqubParameters = .init()
    
    var sendEventOnChangeConfig: Bool = true
    var clientFeatures: VarioqubClientFeatures = .init()
    
}
