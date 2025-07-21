import Foundation
#if VQ_MODULES
import Varioqub
#endif

@objc
public extension VQVarioqubFacade {
    
    func initializeInstance(
        clientId: String,
        config: VQConfig,
        idProvider: VQIdProvider?,
        reporter: VQReporter?
    ) -> VQVarioqubInstance {
        let inst = oriVQ.initializeInstance(
            clientId: clientId,
            config: config.varioqubConfig,
            idProvider: idProvider.map { VQIdProviderProxy(objProvider: $0) },
            reporter: reporter.map { VQReporterProxy(objCReporter: $0) }
        )
        
        return VQVarioqubInstance(originalInstance: inst)
    }
    
    func instance(for clientId: String) -> VQVarioqubInstance {
        VQVarioqubInstance(originalInstance: oriVQ.instance(clientId: clientId))
    }
    
}
