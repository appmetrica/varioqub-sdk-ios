
import Foundation

#if VQ_MODULES
import VarioqubUtils
#endif

struct NetworkDataModel: Equatable {
    var version: Version
    var data: Data
    var fetchDate: Date
}
