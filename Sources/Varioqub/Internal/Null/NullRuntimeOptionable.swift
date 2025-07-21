
final class NullRuntimeOptionable: RuntimeOptionable {
    var sendEventOnChangeConfig: Bool {
        get { return false }
        set { }
    }
    var clientFeatures: ClientFeatures {
        get { return ClientFeatures() }
        set { }
    }
}
