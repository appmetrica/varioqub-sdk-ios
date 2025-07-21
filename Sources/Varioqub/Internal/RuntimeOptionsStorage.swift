#if VQ_MODULES
import VarioqubUtils
#endif


final class RuntimeOptionsStorage {
    let threadChecker: ThreadChecker
    
    init(clientFeatures: ClientFeatures, threadChecker: ThreadChecker) {
        self._clientFeatures = clientFeatures
        self.threadChecker = threadChecker
    }
    
    private var _sendEvent: Bool = true
    private var _clientFeatures: ClientFeatures
}

extension RuntimeOptionsStorage: RuntimeOptionable {
    
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
    
}
