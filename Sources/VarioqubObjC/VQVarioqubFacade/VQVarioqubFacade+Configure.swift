
import Foundation

#if VQ_MODULES
import Varioqub
#endif


@objc
public extension VQVarioqubFacade {

    @discardableResult
    func initialize(clientId: String, config: VQConfig, idProvider: VQIdProvider?, reporter: VQReporter?) -> VQVarioqubInstance {

        let inst = oriVQ.initialize(
            clientId: clientId,
            config: config.varioqubConfig,
            idProvider: idProvider.map { VQIdProviderProxy(objProvider: $0) },
            reporter: reporter.map { VQReporterProxy(objCReporter: $0) }
        )
        
        let vqInstance = VQVarioqubInstance(originalInstance: inst)
        self.mainInstance = vqInstance
        return vqInstance
    }

}
