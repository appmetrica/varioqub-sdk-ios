
final class NullRuntimeOptionable: VarioqubRuntimeOptionable {
    var sendEventOnChangeConfig: Bool {
        get { return false }
        set { }
    }
    var clientFeatures: ClientFeatures {
        get { return ClientFeatures() }
        set { }
    }
    
    var runtimeParams: VarioqubParameters {
        get { VarioqubParameters() }
        set { }
    }
}
