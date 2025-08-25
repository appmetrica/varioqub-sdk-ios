#if VQ_MODULES
import VarioqubUtils
#endif


final class RuntimeOptionsHolder {
    let threadChecker: ThreadChecker
    
    init(clientFeatures: ClientFeatures, threadChecker: ThreadChecker) {
        self._clientFeatures = clientFeatures
        self.threadChecker = threadChecker
    }
    
    private var _sendEvent: Bool = true
    private var _clientFeatures: ClientFeatures
    private var _runtimeParams: VarioqubParameters = .init()
    private var _deeplinkParams: VarioqubParameters = .init()
}

extension RuntimeOptionsHolder: VarioqubRuntimeOptionable, RuntimeOptionsProtocol {
    
    var clientFeatures: ClientFeatures {
        get {
            threadChecker.check()
            return _clientFeatures
        }
        set {
            threadChecker.check()
            _clientFeatures = newValue
        }
    }
    
    
    var sendEventOnChangeConfig: Bool {
        get {
            threadChecker.check()
            return _sendEvent
        }
        set {
            threadChecker.check()
            _sendEvent = newValue
        }
    }
    
    var runtimeParams: VarioqubParameters {
        get {
            threadChecker.check()
            return _runtimeParams
        }
        set {
            threadChecker.check()
            _runtimeParams = newValue
        }
    }
    
    var deeplinkParams: VarioqubParameters {
        get {
            threadChecker.check()
            return _deeplinkParams
        }
        set {
            threadChecker.check()
            _deeplinkParams = newValue
        }
    }
    
}
