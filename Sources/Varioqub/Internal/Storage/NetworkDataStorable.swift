
import Foundation


struct NetworkDataKeyDSO: RawRepresentable, Equatable {
    var rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    static let pending: NetworkDataKeyDSO = .init(rawValue: "pending")
    static let active: NetworkDataKeyDSO = .init(rawValue: "active")
}
