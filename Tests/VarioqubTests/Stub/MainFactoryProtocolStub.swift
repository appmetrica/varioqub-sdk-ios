@testable import Varioqub
import VarioqubUtils


final class MainFactoryProtocolStub: MainFactoryProtocol {

    var _configFetcher: ConfigFetchable!
    var _flagResolver: ConfigUpdaterControllable!
    var _flagUpdater: ConfigUpdaterInput!
    var _threadChecker: ThreadChecker!

    var flagControllable: ConfigUpdaterControllable { _flagResolver }
    var flagUpdater: ConfigUpdaterInput { _flagUpdater }
    var configFetcher: ConfigFetchable { _configFetcher }
    var threadChecker: ThreadChecker { _threadChecker }

}
